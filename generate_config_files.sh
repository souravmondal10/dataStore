mv config_sample.php config.php

sed -i "s/redis_host_xxx/$REDIS_HOST/g" config.php

cat config.php
