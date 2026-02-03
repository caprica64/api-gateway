import AWSLambdaRuntime
import Foundation

struct FactorialRequest: Codable {
    let number: Int
}

struct FactorialResponse: Codable {
    let number: Int
    let factorial: String
    let message: String
    let calculationTime: Double
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
    
    let corsHeaders = """
    {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
    }
    """
    
    // Try to parse the event as JSON
    guard let eventData = event.data(using: .utf8),
          let eventJson = try? JSONSerialization.jsonObject(with: eventData) as? [String: Any] else {
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
        
        let (factorial, calculationTime) = calculateFactorial(number)
        
        let message = "Factorial of \(number) calculated successfully"
        
        let factorialResponse = FactorialResponse(
            number: number,
            factorial: factorial,
            message: message,
            calculationTime: calculationTime
        )
        
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