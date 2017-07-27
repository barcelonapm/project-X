-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Thu Jul 27 22:22:18 2017
-- 
--
-- Table: event
--
DROP TABLE event CASCADE;
CREATE TABLE event (
  id serial NOT NULL,
  name character varying(64) DEFAULT '',
  description text DEFAULT '',
  start_date timestamp,
  end_date timestamp,
  cfp_limit timestamp,
  created timestamp NOT NULL,
  updated timestamp NOT NULL,
  PRIMARY KEY (id)
);
CREATE INDEX start_idx on event (start_date);

--
-- Table: user
--
DROP TABLE user CASCADE;
CREATE TABLE user (
  id serial NOT NULL,
  email character varying(255) DEFAULT '' NOT NULL,
  password character varying(50) DEFAULT '' NOT NULL,
  name character varying(64) DEFAULT '',
  tshirt character varying(32) DEFAULT '',
  bio text DEFAULT '',
  pause character varying(64) DEFAULT '',
  url character varying(255) DEFAULT '',
  role character varying(6) DEFAULT 'human' NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT email UNIQUE (email)
);

--
-- Table: talk
--
DROP TABLE talk CASCADE;
CREATE TABLE talk (
  id serial NOT NULL,
  user_id integer,
  event_id integer,
  title character varying(64) DEFAULT '',
  description text DEFAULT '',
  url character varying(255) DEFAULT '',
  duration integer NOT NULL,
  lang character varying(32) DEFAULT '',
  status character varying(6) DEFAULT 'open' NOT NULL,
  created timestamp NOT NULL,
  updated timestamp NOT NULL,
  PRIMARY KEY (id)
);
CREATE INDEX talk_idx_event_id on talk (event_id);
CREATE INDEX user_idx on talk (user_id);
CREATE INDEX event_idx on talk (event_id);
CREATE INDEX status_idx on talk (status);

--
-- Table: event_user
--
DROP TABLE event_user CASCADE;
CREATE TABLE event_user (
  user_id integer DEFAULT 0 NOT NULL,
  event_id integer DEFAULT 0 NOT NULL,
  role character varying(6) DEFAULT 'human' NOT NULL,
  PRIMARY KEY (event_id, user_id)
);
CREATE INDEX event_user_idx_event_id on event_user (event_id);
CREATE INDEX event_user_idx_user_id on event_user (user_id);

--
-- Table: user_talk
--
DROP TABLE user_talk CASCADE;
CREATE TABLE user_talk (
  user_id integer DEFAULT 0 NOT NULL,
  talk_id integer DEFAULT 0 NOT NULL,
  created timestamp NOT NULL,
  PRIMARY KEY (user_id, talk_id)
);
CREATE INDEX user_talk_idx_talk_id on user_talk (talk_id);
CREATE INDEX user_talk_idx_user_id on user_talk (user_id);

--
-- Foreign Key Definitions
--

ALTER TABLE talk ADD CONSTRAINT talk_fk_event_id FOREIGN KEY (event_id)
  REFERENCES event (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE event_user ADD CONSTRAINT event_user_fk_event_id FOREIGN KEY (event_id)
  REFERENCES event (id) DEFERRABLE;

ALTER TABLE event_user ADD CONSTRAINT event_user_fk_user_id FOREIGN KEY (user_id)
  REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE user_talk ADD CONSTRAINT user_talk_fk_talk_id FOREIGN KEY (talk_id)
  REFERENCES talk (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE user_talk ADD CONSTRAINT user_talk_fk_user_id FOREIGN KEY (user_id)
  REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

