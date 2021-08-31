# DeviceInfoNugetTest

Basic test to troubleshoot WinRT/CPP from 15063 -> 16299.

The premise is supporting ARM for our SDK, which mandates we change our min target.

When the min target is changed, I'm unable to run our sample apps for C++/WinRT.

I've created a barebones framework which demonstrates the issue.

The issue may be with how we are building the nuget as well - so I'm exposing that process in hopes that we can figure out what is the issue.

## To build the nuget:
- Open DeviceInfoFetcher.sln
- Restore all nuget packages for the solution
- Rebuild the project for Release x64/x86
- Run Prepackage.bat (using Developer Command Prompt)
- Verify the files were moved into bin/Release
- Run `nuget pack .\Package.nuspec` in the Package Manager Console

Your nuget will be available as something like `DeviceInfoFetcher.0.0.X.nupkg`

## Integrating the nuget in a sample project

1. Download an example WinRT/CPP project, like the [Clipboard project.](https://github.com/microsoft/Windows-universal-samples/tree/main/Samples/Clipboard/cppwinrt)
2. Open the example project, ensure it compiles and runs fine. 
3. Add the above `DeviceInfoFetcher` nuget to the solution, and do a rebuild to generate the required header projections.
4. Integrate the basic exposed API for this class (see snippet A and snippet B in the below Examples)
5. Compile and run. Observe in the debug console - you should see a message that reports back your advertising ID to prove that the library has been linked.


## Reproducing the issue

### Rebuild the nuget but change the min target.
- Go back to the DeviceInfoFetcher.csproj
- Change the min target of the DeviceInfoFetcher project from 15063 -> 16299
- Clean/Rebuild the project for Release x64/x86
- Run Prepackage.bat (using Developer Command Prompt)
- Verify the files were moved into bin/Release
- To avoid any weird caching/collision issues, bump the Package.nuspec version (e.g: 0.0.5 -> 0.0.6) 
- Run `nuget pack .\Package.nuspec` in the Package Manager Console


### Integrate updated nuget

1. Add the updated `DeviceInfoFetcher` nuget to the solution, and do a rebuild to generate the required header projections.
2. Compile and run. Observe that the app launches, but we'll get the following below fatal exceptions:

> onecore\com\combase\objact\dllcache.cxx(4815)\combase.dll!00007FF966799E71: (caller: 00007FF96668E0F5) ReturnHr(1) tid(6240) 80131040 Exception thrown at 0x00007FF967634ED9 in Clipboard.exe: Microsoft C++ exception: winrt::hresult_error at memory location 0x00000001BF8FE140.

>Exception thrown at 0x00007FF967634ED9 in Clipboard.exe: Microsoft C++ exception: [rethrow] at memory location 0x0000000000000000.
> Exception thrown at 0x00007FF967634ED9 (KernelBase.dll) in Clipboard.exe: WinRT originate error - 0x80131040 : 'The text associated with this error code could not be found.'.
> Invalid parameter passed to C runtime function.

> Activation of the Windows Store app 'Microsoft.SDKSamples.Clipboard.CPPWINRT_8wekyb3d8bbwe!App' failed with error 'Operation not supported. Unknown error: 0x80040905'.




## Examples

### Snippet A

In `App.h` of your sample app, include the header and define DeviceInfo

```c++
#include "App.xaml.g.h"
// Other includes...

#include "winrt/DeviceInfoFetcher.h"

namespace winrt::SDKTemplate::implementation
{
    struct App : AppT<App>
    {
        
        // other code...
        DeviceInfoFetcher::DeviceInfo di{ nullptr };
    
    };
}
```

### Snippet B

In `App.cpp` of your sample app, also include the projected header, then invoke the API call for GetAdvertisingId.

```c++
#include "pch.h"
// Other includes ...

#include <winrt\DeviceInfoFetcher.h>


// Other stuff...

void App::OnLaunched(LaunchActivatedEventArgs const& e)
{
    // Other code here
    di.GetAdvertisingId();
}

```
