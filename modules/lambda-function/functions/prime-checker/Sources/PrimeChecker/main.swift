import AWSLambdaRuntime
import Foundation
import Logging

struct PrimeRequest: Codable {
    let number: Int
}

struct PrimeResponse: Codable {
    let number: Int
    let isPrime: Bool
    let message: String
    let executionTime: Double
}

func isPrime(_ n: Int) -> Bool {
    if n < 2 {
        return false
    }
    if n == 2 {
        return true
    }
    if n % 2 == 0 {
        return false
    }
    
    let limit = Int(sqrt(Double(n)))
    for i in stride(from: 3, through: limit, by: 2) {
        if n % i == 0 {
            return false
        }
    }
    return true
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
    context.logger.info("Prime checker request started", metadata: [
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
        let primeRequest = try JSONDecoder().decode(PrimeRequest.self, from: bodyData)
        let number = primeRequest.number
        
        context.logger.info("Processing prime check", metadata: [
            "requestId": .string(context.requestID),
            "number": .string("\(number)")
        ])
        
        let calculationStart = Date().timeIntervalSince1970
        let prime = isPrime(number)
        let calculationTime = Date().timeIntervalSince1970 - calculationStart
        
        let message = prime ? 
            "\(number) is a prime number" : 
            "\(number) is not a prime number"
        
        let executionTime = Date().timeIntervalSince1970 - startTime
        
        let primeResponse = PrimeResponse(
            number: number,
            isPrime: prime,
            message: message,
            executionTime: executionTime
        )
        
        context.logger.info("Prime check completed", metadata: [
            "requestId": .string(context.requestID),
            "number": .string("\(number)"),
            "isPrime": .string("\(prime)"),
            "calculationTime": .string("\(calculationTime)s"),
            "totalExecutionTime": .string("\(executionTime)s")
        ])
        
        let responseData = try JSONEncoder().encode(primeResponse)
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