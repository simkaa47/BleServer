using DotnetBleServer.Advertisements;
using DotnetBleServer.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BleServer.Console
{
    class SampleAdvertisement
    {
        public static async Task RegisterSampleAdvertisement(ServerContext serverContext)
        {
            var advertisementProperties = new AdvertisementProperties
            {
                Type = "peripheral",
                ServiceUUIDs = new[] { "12345678-1234-5678-1234-56789abcdef0" },
                LocalName = "Orange Pi",
            };

            await new AdvertisingManager(serverContext).CreateAdvertisement(advertisementProperties);
        }
    }
}
