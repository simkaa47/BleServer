using BleServer.Console;
using DotnetBleServer.Advertisements;
using DotnetBleServer.Core;
using DotnetBleServer.Gatt.Description;
using DotnetBleServer.Gatt;
using Linux.Bluetooth;
using Linux.Bluetooth.Extensions;
using System.Diagnostics;

internal class Program
{
    private static async Task Main(string[] args)
    {
        if (args.Contains("--wait-for-attach"))
        {
            Console.WriteLine("Attach debugger and use 'Set next statement'");
            while (true)
            {
                Thread.Sleep(100);
                if (Debugger.IsAttached)
                    break;
            }
        }
        if (OperatingSystem.IsLinux())
        {
            Task.Run(async () =>
            {
                using (var serverContext = new ServerContext())
                {
                    await serverContext.Connect();
                    await SampleAdvertisement.RegisterSampleAdvertisement(serverContext);
                    await SampleGattApplication.RegisterGattApplication(serverContext);

                    Console.WriteLine("Press CTRL+C to quit");
                    await Task.Delay(-1);
                }
            }).Wait();
        }

            //var adapter = (await BlueZManager.GetAdaptersAsync()).FirstOrDefault();
            //if (adapter is not null)
            //{
            //    var name = await adapter.GetNameAsync();
            //    var id = await adapter.GetAddressAsync();
            //    Console.WriteLine($"Adapter name is {name}");
            //    Console.WriteLine($"Adapter address is {id}");
            //    IGattService1 service = adapter.
            //}   
       

       
    }
}
