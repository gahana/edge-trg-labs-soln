# Update a store

1. Get a store detail

```bash
$ curl -i -n https://srinis-test.apigee.net/sales/v1/stores/Pleasant
```

Trying to update phone number should fail

```bash
$ curl -i -n -H "Content-Type: application/json" -X PUT 'https://srinis-test.apigee.net/sales/v1/stores/Pleasant' -d '{ "phone" : "111-111-1111" }'
```

2. Create a new encrypted KVM `baas` with entries `clientId` and `clientSecret`

3. Create a conditional flow in `trg-stores-api` proxy's target request flow.

4. Add KVM Operations policy to get `clientId` and `clientSecret` from KVM

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<KeyValueMapOperations async="false" continueOnError="false" enabled="true" name="KVM-GetClientCreds" mapIdentifier="baas">
    <DisplayName>KVM-GetClientCreds</DisplayName>
    <Get assignTo="private.baas_clientId" index="1">
        <Key>
            <Parameter>clientId</Parameter>
        </Key>
    </Get>
    <Get assignTo="private.baas_clientSecret" index="1">
        <Key>
            <Parameter>clientSecret</Parameter>
        </Key>
    </Get>
    <Scope>environment</Scope>
</KeyValueMapOperations>
```

5. Add Basic Authentication policy

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<BasicAuthentication async="false" continueOnError="false" enabled="true" name="Basic-Authentication-1">
    <DisplayName>Basic Authentication-1</DisplayName>
    <Operation>Encode</Operation>
    <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
    <User ref="private.baas_clientId"/>
    <Password ref="private.baas_clientSecret"/>
    <AssignTo createNew="false">request.header.Authorization</AssignTo>
</BasicAuthentication>
```

# Prevent DoS attacks on backend service

1. Add Spike Arrest policy

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<SpikeArrest async="false" continueOnError="false" enabled="true" name="Spike-Arrest-1">
    <DisplayName>Spike Arrest-1</DisplayName>
    <Properties/>
    <Rate>2pm</Rate>
</SpikeArrest>
```

2. Test
A second request within 30 seconds should fail.

```bash
$ curl -i -n 'https://srinis-test.apigee.net/sales/v1/stores/Pleasant'; curl -i -n 'https://srinis-test.apigee.net/sales/v1/stores/Pleasant'
```

# Apply Quota for Stores API operations.

1. Create an API product `trg-sales-product` with quota set to 2pm

2. Create an Application `trg-sales-app` and get the `consumer key`

3. Apply Verify API key policy on `trg-stores-api`

4. Apply Quota policy on `trg-stores-api`

```xml
<Allow count="2" countRef="verifyapikey.Verify-API-Key-1.apiproduct.developer.quota.limit"/>
<Interval ref="verifyapikey.Verify-API-Key-1.apiproduct.developer.quota.interval">1</Interval>
<TimeUnit ref="verifyapikey.Verify-API-Key-1.apiproduct.developer.quota.timeunit">minute</TimeUnit>
```
This picks up quota attributes defined on the API product.



5. Test
- A third request within the minute should fail
- After a minute 2 more requests should succeed before the third one fails again

6. To pick quota values from application, define custom attribute on application. To pick quota attributes from Application, directly mention the attribute without any prefix on Quota policy

```xml
<Allow count="2" countRef="app_quota_limit"/>
<Interval ref="app_quota_interval">1</Interval>
<TimeUnit ref="app_quota_timeunit">minute</TimeUnit>
```

