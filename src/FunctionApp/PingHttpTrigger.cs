using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.OpenApi.Models;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using System.Net;

namespace azureApplication
{
    public  class PingHttpTrigger
    {
        private readonly IMyService _service;
        public PingHttpTrigger(IMyService service)
        {
            this._service = service ?? throw new ArgumentNullException(nameof(service));
        }
        
        // 문자열 하드 코딩보다 이게 참조하기 더 편함
        [FunctionName(nameof(PingHttpTrigger))]

        [OpenApiOperation(operationId: "Ping",tags:new[]{"greeting"})]
        [OpenApiSecurity(schemeName:"function_key",schemeType:SecuritySchemeType.ApiKey,Name =  "x-functions-key",In =OpenApiSecurityLocationType.Header)]
        //Name=coe, .query

        [OpenApiParameter(name:"name",In =ParameterLocation.Query,Required =true,Description ="Name of the person to greet")]
        [OpenApiResponseWithBody(statusCode:HttpStatusCode.OK, contentType:"application/json", bodyType:typeof(ResponseMessage),Description ="greetingMessage")]

        public  IActionResult Run(

        //api auth 적용
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "ping")] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];


            //validation 정도만 controller 느낌
            //로직의 경우 서비스에 양도

            // 이경우 의존성 주입 ㄴㄴ 해야함
            // var service= new Myservice();
            var result=this._service.GetMessage(name);
        
            

            var res=new ResponseMessage(){Message = result};

            return new OkObjectResult(res);
        }
    }

public class ResponseMessage
{   [JsonProperty("response_message")]
    public string Message{get;set;}
}

public interface IMyService
{
    string GetMessage(string name);
}

public class MyService :IMyService
{
    public string GetMessage(string name)
    {
        string responseMessage = string.IsNullOrEmpty(name)
         ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
                : $"Hello, {name}. This HTTP triggered function executed successfully.";

        return responseMessage;
    }
}

}

//yaml- swagger.yaml , api/openapi/v3.json  