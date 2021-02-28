export DOTNET_CLI_TELEMETRY_OPTOUT=1
return 0

# export DOTNET_ROOT=/snap/dotnet-sdk/current
# version=$(${DOTNET_ROOT}/dotnet --version)
# export MSBuildSDKsPath=${DOTNET_ROOT}/sdk/${version}/Sdks
# export MSBuildExtensions=${DOTNET_ROOT}/sdk/${version}/Microsoft/Microsoft.NET.Build.Extensions/net461/lib
# export PATH="${PATH}:${DOTNET_ROOT}:${DOTNET_ROOT}/sdk/${version}:${MSBuildExtensions}:$HOME/.dotnet/tools"

# FIX mike@carif.io: snap dotnet-sdk seems to be almost completely broken?
# alias scriptcs=~/.nuget/packages/scriptcs/0.17.1/tools/scriptcs.exe

function dn-get-tool {
    u.have.command $1 || u.have.command dotnet || dotnet tool install -g $1 &
}

dn-get-tool dotnet-script # https://github.com/filipw/dotnet-script
dn-get-tool dotnet-ildasm # https://github.com/pjbgf/dotnet-ildasm

