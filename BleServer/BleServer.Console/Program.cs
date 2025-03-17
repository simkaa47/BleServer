using Linux.Bluetooth;

if (OperatingSystem.IsLinux())
{
    IAdapter1? adapter = (await BlueZManager.GetAdaptersAsync()).FirstOrDefault();
    if(adapter is not null)
    {
        var name = await adapter.GetNameAsync();
        var id = await adapter.GetAddressAsync();
        Console.WriteLine($"Adapter name is {name}");
        Console.WriteLine($"Adapter address is {id}");
    }
}
Console.WriteLine("End of the program!");
