
	update the sso plan name in gateway-service-config.json
		ratatta: uaa
		pcfone: dekt-prod

cf create-service p.gateway standard animals-gw -c animals-TAS-GW.json

	(created the SSO service automatically)

	while creating login to login to p-identity.<sys domain> as admin show other plans

	show gateway management portal, with base url, sso and empty route

cf push

./route_updates static 

	show direct access to each microservice is blocked

	show routes refreshed

animals.<apps domain>/rescue

	log out in /rescue BEFOR showing the GW dashboard, know issue being fixed

	update in gateway-frontend-config:

"filters": [ "RateLimit=2,10s" ]

./route_updates dynamic 

curl -k https://animals.<apps domain>/rescue

	3 times in 10 seconds to show rate limit 
	
	curl -k https://dekt4pets.apps.pcfone.io/rescue

cf service-logs animals-TAS-gw --skip-ssl-validation

	look at GW logs (requires the service cli plugin: cf install-plugin -r CF-Community "Service Instance Logging"

