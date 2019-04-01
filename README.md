# Docker-Aircraftsync

This will use subversion to sync down the [FlightGear](http://home.flightgear.org/) Aircraft to the specified volume.

## Usage

With Docker run:

```bash
docker run \
    --rm \
    --name=aircraftsync \
    -e URL="https://svn.code.sf.net/p/flightgear/fgaddon/branches/release-2018.3/" \
    -e PUID=1000 \
    -e PGID=1000 \
    -v </path/to/your/share>:/dist \
    cgspeck/aircraftsync:latest
```

The aircraft will be synced to `/dist/Aircraft`.

You can also add the following commands to the end of the run command to  change the way it behaves:

**`console`**

Bring up a bash terminal within the container.

**`cleanup`**

Run `svn cleanup`, e.g. fix a broken checkout.

**`root`**

Bring up a root terminal within the container.

## Parameters

Parameter | Function
--- | ---
-e URL="http://svn.code.sf.net/p/flightgear/fgaddon/branches/release-2018.3/Aircraft" | Which subversion repository to clone aircraft from
-e PUID=1000 | User ID
-e PGID=1000 | Group ID

### User / Group Identifiers

You can specify user ID and group IDs for use in the container to avoid permission issues between the container and the host.

Ensure any volume directories on the host are owned by the same user you specify.

You can use `id` to find your user id and group id:

```
$ id foo
uid=1000(foo) gid=1000(foo)
```

### Subversion URLS

The url is in the form of:

* `https://svn.code.sf.net/p/flightgear/fgaddon/branches/release-{major version}.{minor version}/Aircraft` or
* `http://svn.code.sf.net/p/flightgear/fgaddon/trunk/Aircraft` if you want development/latest
