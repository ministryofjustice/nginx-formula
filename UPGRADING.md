Version 3.5.0
----

Default behaviour change: We no longer send out UDP events during nginx
restarts

Version 3.0.0
----

No changes needed unless enforce_www or enforce_no_www were used.

If they were, then you must ensure that this redirect is instead performed by
a system in front of these nginx instances. Eg sslloadbalancer-formula
