CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";


CREATE TABLE users
(

    "id"           UUID      NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    "username"     TEXT      NOT NULL UNIQUE,
    "display_name" TEXT      NOT NULL,
    "password"     text      NOT NULL,
    "joined"       timestamp NOT NULL DEFAULT now()
);

CREATE TABLE items
(
    "id"      uuid      NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    "title"   text               DEFAULT NULL UNIQUE,
    "current" uuid      NOT NULL,
    "created" timestamp NOT NULL DEFAULT now()
);

CREATE TABLE item_versions
(
    "id"        uuid      NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    "item_id"   uuid      NOT NULL
        CONSTRAINT "version_item_id" REFERENCES items ON DELETE CASCADE,
    "title"     text               DEFAULT NULL,
    "source"    text               DEFAULT '',
    "media_id"  uuid               DEFAULT NULL,
    "mime_type" text      NOT NULL DEFAULT 'text/vnd.spellbook',
    "author_id" uuid
        CONSTRAINT "history_item_author" REFERENCES users ON DELETE SET NULL,
    "created"   timestamp NOT NULL DEFAULT now()
);

CREATE TABLE media
(

    "id"        uuid NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    "mime_type" text NOT NULL,
    "filename"  text NOT NULL,
    "path"      text NOT NULL
);

ALTER TABLE items
    ADD CONSTRAINT "current_version" FOREIGN KEY (current) REFERENCES item_versions ON DELETE RESTRICT;

CREATE TABLE item_relations
(
    "from" uuid NOT NULL
        CONSTRAINT "item_relation_from" REFERENCES items ON DELETE CASCADE,
    "to"   uuid NOT NULL
        CONSTRAINT "item_relation_to" REFERENCES items ON DELETE CASCADE,
    CONSTRAINT "item_relation" PRIMARY KEY ("from", "to")
);
