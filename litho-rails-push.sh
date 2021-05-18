rails app:template LOCATION=https://raw.githubusercontent.com/ThryvInc/litho-tools/master/rails-push/push_template.rb

rails g model Device push_id platform
rails g migration AddPushProviderIdToUsers push_provider_id:string
rails g migration AddUserRefToDevices user:references

SCRIPT_DIR=`dirname "$BASH_SOURCE"`
echo $SCRIPT_DIR

cp -r "$SCRIPT_DIR/rails-push/one_signal.rb" ./config/initializers/one_signal.rb

cp -r "$SCRIPT_DIR/rails-push/controllers/" ./app/controllers/api/v1/
cp -r "$SCRIPT_DIR/rails-push/device.rb" ./app/models/device.rb
cp -r "$SCRIPT_DIR/rails-push/views/" ./app/views/api/v1/devices/

cp -r "$SCRIPT_DIR/rails-push/spec/device_spec.rb" ./spec/models/
cp -r "$SCRIPT_DIR/rails-push/spec/devices_spec.rb" ./spec/requests/

echo "You'll need to set these env variables: ONESIGNAL_APP_ID, ONESIGNAL_API_KEY, and ONESIGNAL_USER_KEY"
