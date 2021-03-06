# ghost-docker

Docker library for [Ghost](https://github.com/levee223/ghost).

## How to use this image

### Docker Compose

```yaml
version: "3.7"

services:
  ghost:
    image: levee223/ghost:latest
    restart: always
    depends_on:
      - db
    ports:
      - 2368:2368
    volumes:
      - ghost-images:/var/lib/ghost/content/images
      - ghost-settings:/var/lib/ghost/content/settings
      - /mnt/ghost-overlay/additional-head2.hbs:/var/lib/ghost/content/themes/casper/partials/additional-head2.hbs:ro
      - /mnt/ghost-overlay/additional-foot2.hbs:/var/lib/ghost/content/themes/casper/partials/additional-foot2.hbs:ro
      - /mnt/ghost-overlay/post-comments.hbs:/var/lib/ghost/content/themes/casper/partials/post-comments.hbs:ro
      - /mnt/ghost-overlay/site-nav-search.hbs:/var/lib/ghost/content/themes/casper/partials/site-nav-search.hbs:ro
      - /mnt/ghost-overlay/site-nav-right-addons.hbs:/var/lib/ghost/content/themes/casper/partials/site-nav-right-addons.hbs:ro
    environment:
      url: http://1.2.3.4:2368
      database__client: mysql
      database__connection__host: db
      database__connection__user: root
      database__connection__password: example
      database__connection__database: ghost
      mail__transport: SMTP
      mail__options__host: smtp.example.com
      mail__options__port: 587
      mail__from: "'Acme Support' <support@example.com>"
      privacy__useUpdateCheck: "false"
      privacy__useGravatar: "false"
      privacy__useRpcPing: "false"
      referrerPolicy: no-referrer

  db:
    image: mysql:5.7
    restart: always
    volumes:
      - db-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: example

  isso:
    image: wonderfall/isso:latest
    restart: always
    depends_on:
      - ghost
    ports:
      - 8080:8080
    volumes:
      - isso-db:/db
      - /mnt/isso-overlay/isso-config:/config

volumes:
  ghost-images:
  ghost-settings:
  db-data:
  isso-db:
```
