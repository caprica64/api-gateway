import AWSLambdaRuntime
import Foundation
import Logging

struct FactorialRequest: Codable {
    let number: Int
}

struct FactorialResponse: Codable {
    let number: Int
    let factorial: String
    let message: String
    let calculationTime: Double
    let executionTime: Double
}

func calculateFactorial(_ n: Int) -> (result: String, time: Double) {
    let startTime = Date().timeIntervalSince1970
    
    guard n >= 0 else {
        let endTime = Date().timeIntervalSince1970
        return ("Invalid input", endTime - startTime)
    }
    
    if n == 0 || n == 1 {
        let endTime = Date().timeIntervalSince1970
        return ("1", endTime - startTime)
    }
    
    // For large numbers, use string-based calculation to avoid overflow
    if n > 20 {
        var result = "1"
        for i in 2...n {
            result = multiplyStrings(result, String(i))
        }
        let endTime = Date().timeIntervalSince1970
        return (result, endTime - startTime)
    } else {
        // For smaller numbers, use standard calculation
        var result: Int64 = 1
        for i in 2...n {
            result *= Int64(i)
        }
        let endTime = Date().timeIntervalSince1970
        return (String(result), endTime - startTime)
    }
}

func multiplyStrings(_ num1: String, _ num2: String) -> String {
    let n1 = Array(num1.reversed())
    let n2 = Array(num2.reversed())
    var result = Array(repeating: 0, count: n1.count + n2.count)
    
    for i in 0..<n1.count {
        for j in 0..<n2.count {
            let digit1 = Int(String(n1[i])) ?? 0
            let digit2 = Int(String(n2[j])) ?? 0
            let mul = digit1 * digit2
            let sum = mul + result[i + j]
            
            result[i + j] = sum % 10
            result[i + j + 1] += sum / 10
        }
    }
    
    // Remove leading zeros and convert to string
    while result.count > 1 && result.last == 0 {
        result.removeLast()
    }
    
    return String(result.reversed().map { String($0) }.joined())
}

// Lambda handler using the 0.5.2 API with string-based handler
Lambda.run { (context: Lambda.Context, event: String, callback: @escaping (Result<String, Error>) -> Void) in
    
    let startTime = Date().timeIntervalSince1970
    
    let corsHeaders = """
    {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
    }
    """
    
    // Log request start
    context.logger.info("Factorial calculator request started", metadata: [
        "requestId": .string(context.requestID),
        "remainingTime": .string("\(context.getRemainingTime())ms")
    ])
    
    // Try to parse the event as JSON
    guard let eventData = event.data(using: .utf8),
          let eventJson = try? JSONSerialization.jsonObject(with: eventData) as? [String: Any] else {
        context.logger.error("Invalid request format", metadata: [
            "requestId": .string(context.requestID),
            "event": .string(String(event.prefix(200)))
        ])
        let errorResponse = """
        {
            "statusCode": 400,
            "headers": \(corsHeaders),
            "body": "{\\"error\\": \\"Invalid request format\\"}"
        }
        """
        callback(.success(errorResponse))
        return
    }
    
    // Handle OPTIONS request for CORS
    if let httpMethod = eventJson["httpMethod"] as? String, httpMethod == "OPTIONS" {
        context.logger.info("CORS preflight request handled", metadata: [
            "requestId": .string(context.requestID),
            "method": .string(httpMethod)
        ])
        let response = """
        {
            "statusCode": 200,
            "headers": \(corsHeaders),
            "body": ""
        }
        """
        callback(.success(response))
        return
    }
    
    // Get the body from the event
    guard let bodyString = eventJson["body"] as? String,
          let bodyData = bodyString.data(using: .utf8) else {
        context.logger.error("Invalid request body", metadata: [
            "requestId": .string(context.requestID)
        ])
        let errorResponse = """
        {
            "statusCode": 400,
            "headers": \(corsHeaders),
            "body": "{\\"error\\": \\"Invalid request body\\"}"
        }
        """
        callback(.success(errorResponse))
        return
    }
    
    do {
        let factorialRequest = try JSONDecoder().decode(FactorialRequest.self, from: bodyData)
        let number = factorialRequest.number
        
        // Validate input range
        guard number >= 0 && number <= 1000 else {
            context.logger.warning("Input out of range", metadata: [
                "requestId": .string(context.requestID),
                "number": .string("\(number)"),
                "validRange": .string("0-1000")
            ])
            let errorResponse = """
            {
                "statusCode": 400,
                "headers": \(corsHeaders),
                "body": "{\\"error\\": \\"Number must be between 0 and 1000\\"}"
            }
            """
            callback(.success(errorResponse))
            return
        }
        
        context.logger.info("Processing factorial calculation", metadata: [
            "requestId": .string(context.requestID),
            "number": .string("\(number)"),
            "algorithm": .string(number > 20 ? "string-based" : "standard")
        ])
        
        let (factorial, calculationTime) = calculateFactorial(number)
        let executionTime = Date().timeIntervalSince1970 - startTime
        
        let message = "Factorial of \(number) calculated successfully"
        
        let factorialResponse = FactorialResponse(
            number: number,
            factorial: factorial,
            message: message,
            calculationTime: calculationTime,
            executionTime: executionTime
        )
        
        context.logger.info("Factorial calculation completed", metadata: [
            "requestId": .string(context.requestID),
            "number": .string("\(number)"),
            "resultLength": .string("\(factorial.count) digits"),
            "calculationTime": .string("\(calculationTime)s"),
            "totalExecutionTime": .string("\(executionTime)s"),
            "algorithm": .string(number > 20 ? "string-based" : "standard")
        ])
        
        let responseData = try JSONEncoder().encode(factorialResponse)
        let responseBody = String(data: responseData, encoding: .utf8) ?? "{\"error\": \"Encoding error\"}"
        
        let response = """
        {
            "statusCode": 200,
            "headers": \(corsHeaders),
            "body": "\(responseBody.replacingOccurrences(of: "\"", with: "\\\""))"
        }
        """
        callback(.success(response))
        
    } catch {
        context.logger.error("Error processing request", metadata: [
            "requestId": .string(context.requestID),
            "error": .string("\(error)")
        ])
        let errorResponse = """
        {
            "statusCode": 400,
            "headers": \(corsHeaders),
            "body": "{\\"error\\": \\"Invalid input. Please provide a valid number.\\"}"
        }
        """
        callback(.success(errorResponse))
    }
}