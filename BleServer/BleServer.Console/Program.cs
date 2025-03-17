using Linux.Bluetooth;
using Linux.Bluetooth.Extensions;

if (OperatingSystem.IsLinux())
{
    IAdapter1? adapter = (await BlueZManager.GetAdaptersAsync()).FirstOrDefault();
    if(adapter is not null)
    {
        var name = await adapter.GetNameAsync();
        var id = await adapter.GetAddressAsync();
        Console.WriteLine($"Adapter name is {name}");
        Console.WriteLine($"Adapter address is {id}");
        await adapter.SetAliasAsync("MyDevice");
    }
}
Console.ReadKey();

Console.WriteLine("End of the program!");
