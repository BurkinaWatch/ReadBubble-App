--
-- PostgreSQL database dump
--

\restrict 6wOubmvbBnWoTyGzKaqS2FkThFdthXcsIhyyvTHu25OYXIN90MQz0Lgwg40cMd8

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    display_name text DEFAULT ''::text NOT NULL,
    history jsonb DEFAULT '[]'::jsonb NOT NULL,
    settings jsonb,
    is_premium boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password_hash, display_name, history, settings, is_premium, created_at, updated_at) FROM stdin;
1ef084ae-ae94-47f3-ab12-9dbaec86ef1d	test@test.com	$2b$10$refiMUBYQWOjZoaUbi1fdepwaVaIxTFeGWnN4utaJxAm0FRMGemq.	test	[]	null	f	2026-03-16 01:48:36.326+00	2026-03-16 16:15:43.286444+00
d3c159fd-cddc-4d35-bab7-c5e921a7a8c5	discretestuds@gmail.com	$2b$10$kR.mxFgzjYPVPHIQgTkpz.zKkzyXBXeqayAxUMUlknJKv4BVwbh/m	discretestuds	[{"id": "17735115096705fhswi2cu", "date": "2026-03-14T18:05:09.670Z", "text": "hello how are", "title": "Texte tapé", "duration": 4}, {"id": "17735115081924racmieke", "date": "2026-03-14T18:05:08.192Z", "text": "hello how are", "title": "Texte tapé", "duration": 3}, {"id": "1773510638977c2kn1hab7", "date": "2026-03-14T17:50:38.977Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 9}, {"id": "1773510620752wghev1mgh", "date": "2026-03-14T17:50:20.752Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 10}, {"id": "1773510608396a23cttoui", "date": "2026-03-14T17:50:08.396Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 4}, {"id": "1773510275364fsi5l469g", "date": "2026-03-14T17:44:35.364Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 4}, {"id": "1773510213118nsal2t3o3", "date": "2026-03-14T17:43:33.118Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 3}, {"id": "1773510202052gd27h9b3v", "date": "2026-03-14T17:43:22.052Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 7}, {"id": "17735101992081ei1yzlgy", "date": "2026-03-14T17:43:19.208Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 4}, {"id": "17734760401014ka021bdt", "date": "2026-03-14T08:14:00.101Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 22}, {"id": "1773476029306botc72wak", "date": "2026-03-14T08:13:49.306Z", "text": "L'intelligence artificielle transforme notre monde a une vitesse vertigineuse. Des algorithmes de plus en plus sophistiques apprennent a resoudre des problemes complexes...", "title": "Article: Intelligence Artificielle", "duration": 12}]	{"rate": 0.5, "pitch": 1, "voice": "", "volume": 1, "autoRead": false, "language": "fr-FR", "ocrEnabled": true, "saveHistory": true, "highlightWords": true, "playerFontSizeIdx": 1}	f	2026-03-16 01:49:12.419+00	2026-03-16 16:15:43.29004+00
\.


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict 6wOubmvbBnWoTyGzKaqS2FkThFdthXcsIhyyvTHu25OYXIN90MQz0Lgwg40cMd8

