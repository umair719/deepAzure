import sys
import iothub_service_client
from iothub_service_client import IoTHubRegistryManager, IoTHubRegistryManagerAuthMethod
from iothub_service_client import IoTHubDeviceStatus, IoTHubError

# Connection to IOT Hub that was created in Portal or AZ CLI
CONNECTION_STRING = "HostName=DAIoTHubv3.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=OQMJm48tqzRbpn6yY+TeP0po6svhTZeX/5WusV+6fsc="
DEVICE_ID = "DianesFakeDevice"

# Print statements of metadata of the IOT Hub (note: you can compare this to the Portal IOT Hub metadata)
def print_device_info(title, iothub_device):
    print ( title + ":" )
    print ( "iothubDevice.deviceId                    = {0}".format(iothub_device.deviceId) )
    print ( "iothubDevice.primaryKey                  = {0}".format(iothub_device.primaryKey) )
    print ( "iothubDevice.secondaryKey                = {0}".format(iothub_device.secondaryKey) )
    print ( "iothubDevice.connectionState             = {0}".format(iothub_device.connectionState) )
    print ( "iothubDevice.status                      = {0}".format(iothub_device.status) )
    print ( "iothubDevice.lastActivityTime            = {0}".format(iothub_device.lastActivityTime) )
    print ( "iothubDevice.cloudToDeviceMessageCount   = {0}".format(iothub_device.cloudToDeviceMessageCount) )
    print ( "iothubDevice.isManaged                   = {0}".format(iothub_device.isManaged) )
    print ( "iothubDevice.authMethod                  = {0}".format(iothub_device.authMethod) )
    print ( "" )
    
# Function to create the device using the Registry Manager.
def iothub_createdevice():
    try:
        iothub_registry_manager = IoTHubRegistryManager(CONNECTION_STRING)
        auth_method = IoTHubRegistryManagerAuthMethod.SHARED_PRIVATE_KEY
        new_device = iothub_registry_manager.create_device(DEVICE_ID, "", "", auth_method)
        print_device_info("CreateDevice", new_device)

    except IoTHubError as iothub_error:
        print ( "Unexpected error {0}".format(iothub_error) )
        return
    except KeyboardInterrupt:
        print ( "iothub_createdevice stopped" )

# Main function
if __name__ == '__main__':
    print ( "" )
    print ( "Python {0}".format(sys.version) )
    print ( "Creating device using the Azure IoT Hub Service SDK for Python" )
    print ( "" )
    print ( "    Connection string = {0}".format(CONNECTION_STRING) )
    print ( "    Device ID         = {0}".format(DEVICE_ID) )

    iothub_createdevice()