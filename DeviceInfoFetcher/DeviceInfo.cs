using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.System.UserProfile;

namespace DeviceInfoFetcher
{
    public sealed class DeviceInfo {
        private const string TAG = "[DevInfo]";

        public static string GetAdvertisingId()
        {
            string adID = AdvertisingManager.AdvertisingId;
            LogMsg(TAG, "Here's your id: " + adID);
            return adID;
        }

        private static void LogMsg(string tag, string msg)
        {
            Debug.WriteLine(tag + msg);
        }
    }
}
