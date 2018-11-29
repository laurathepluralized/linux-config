From this stackoverflow answer:
https://stackoverflow.com/questions/2135478/how-to-simulate-the-environment-cron-executes-a-script-with/2546509#2546509

How to set a shell to use the environment cron uses to run cron jobs:

Add this to your cron[tab]:

   30 08 * * * env > ~/cronenv

After it runs, do this:

   env - `cat ~/cronenv` /bin/sh

This assumes that your cron runs `/bin/sh`, which is the default regardless of the user's default shell.

