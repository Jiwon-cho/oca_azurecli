using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;


[assembly: FunctionsStartup(typeof(azureApplication.Startup))]
namespace azureApplication
{
    public class Startup: FunctionsStartup

    {
        public override void Configure(IFunctionsHostBuilder builder){
            builder.Services.AddScoped<IMyService, MyService>();
        }

    }
}