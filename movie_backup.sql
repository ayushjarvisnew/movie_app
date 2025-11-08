--
-- PostgreSQL database dump
--

\restrict s1PCbtD08n6lfdLsaFEPdu1aurfZ5GEkdzUctnjGqQoz6e7pkjpcYsKAmGNzTo7

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    showtime_id bigint NOT NULL,
    seat_ids json DEFAULT '[]'::json,
    txnid character varying,
    status character varying,
    amount numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bookings_id_seq OWNER TO postgres;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: movie_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_tags (
    id bigint NOT NULL,
    movie_id bigint NOT NULL,
    tag_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.movie_tags OWNER TO postgres;

--
-- Name: movie_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_tags_id_seq OWNER TO postgres;

--
-- Name: movie_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_tags_id_seq OWNED BY public.movie_tags.id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies (
    id bigint NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    poster_image character varying,
    release_date date,
    duration integer,
    rating double precision,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.movies OWNER TO postgres;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movies_id_seq OWNER TO postgres;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: movies_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies_tags (
    movie_id bigint NOT NULL,
    tag_id bigint NOT NULL
);


ALTER TABLE public.movies_tags OWNER TO postgres;

--
-- Name: reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservations (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    showtime_id bigint NOT NULL,
    seats_count integer NOT NULL,
    total_amount numeric,
    payment_status character varying DEFAULT 'pending'::character varying NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    txnid character varying
);


ALTER TABLE public.reservations OWNER TO postgres;

--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservations_id_seq OWNER TO postgres;

--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;


--
-- Name: reservations_seats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservations_seats (
    reservation_id bigint NOT NULL,
    seat_id bigint NOT NULL
);


ALTER TABLE public.reservations_seats OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: screens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.screens (
    id bigint NOT NULL,
    theatre_id bigint NOT NULL,
    name character varying NOT NULL,
    total_seats integer NOT NULL,
    screen_type character varying,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.screens OWNER TO postgres;

--
-- Name: screens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.screens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.screens_id_seq OWNER TO postgres;

--
-- Name: screens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.screens_id_seq OWNED BY public.screens.id;


--
-- Name: seats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seats (
    id bigint NOT NULL,
    screen_id bigint NOT NULL,
    "row" character varying NOT NULL,
    seat_number character varying NOT NULL,
    seat_type character varying DEFAULT 'Regular'::character varying NOT NULL,
    price numeric,
    available boolean DEFAULT true NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.seats OWNER TO postgres;

--
-- Name: seats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seats_id_seq OWNER TO postgres;

--
-- Name: seats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seats_id_seq OWNED BY public.seats.id;


--
-- Name: showtime_seats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.showtime_seats (
    id bigint NOT NULL,
    showtime_id bigint NOT NULL,
    seat_id bigint NOT NULL,
    available boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.showtime_seats OWNER TO postgres;

--
-- Name: showtime_seats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.showtime_seats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.showtime_seats_id_seq OWNER TO postgres;

--
-- Name: showtime_seats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.showtime_seats_id_seq OWNED BY public.showtime_seats.id;


--
-- Name: showtimes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.showtimes (
    id bigint NOT NULL,
    movie_id bigint NOT NULL,
    screen_id bigint NOT NULL,
    start_time timestamp(6) without time zone NOT NULL,
    end_time timestamp(6) without time zone NOT NULL,
    language character varying NOT NULL,
    available_seats integer NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.showtimes OWNER TO postgres;

--
-- Name: showtimes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.showtimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.showtimes_id_seq OWNER TO postgres;

--
-- Name: showtimes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.showtimes_id_seq OWNED BY public.showtimes.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: theatres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.theatres (
    id bigint NOT NULL,
    name character varying NOT NULL,
    address character varying NOT NULL,
    city character varying NOT NULL,
    state character varying NOT NULL,
    country character varying NOT NULL,
    rating numeric,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.theatres OWNER TO postgres;

--
-- Name: theatres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.theatres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.theatres_id_seq OWNER TO postgres;

--
-- Name: theatres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.theatres_id_seq OWNED BY public.theatres.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    phone character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: movie_tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_tags ALTER COLUMN id SET DEFAULT nextval('public.movie_tags_id_seq'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Name: reservations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);


--
-- Name: screens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screens ALTER COLUMN id SET DEFAULT nextval('public.screens_id_seq'::regclass);


--
-- Name: seats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seats ALTER COLUMN id SET DEFAULT nextval('public.seats_id_seq'::regclass);


--
-- Name: showtime_seats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtime_seats ALTER COLUMN id SET DEFAULT nextval('public.showtime_seats_id_seq'::regclass);


--
-- Name: showtimes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtimes ALTER COLUMN id SET DEFAULT nextval('public.showtimes_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: theatres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.theatres ALTER COLUMN id SET DEFAULT nextval('public.theatres_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-11-03 09:31:49.263851	2025-11-03 09:31:49.263853
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, showtime_id, seat_ids, txnid, status, amount, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: movie_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_tags (id, movie_id, tag_id, created_at, updated_at) FROM stdin;
1	1	1	2025-11-03 09:46:56.34832	2025-11-03 09:46:56.34832
2	2	1	2025-11-03 09:47:06.001974	2025-11-03 09:47:06.001974
3	2	2	2025-11-03 09:47:06.004207	2025-11-03 09:47:06.004207
4	3	1	2025-11-03 10:06:38.505892	2025-11-03 10:06:38.505892
5	3	6	2025-11-03 10:06:38.508367	2025-11-03 10:06:38.508367
6	4	8	2025-11-03 10:07:38.425466	2025-11-03 10:07:38.425466
7	5	9	2025-11-03 10:08:44.163993	2025-11-03 10:08:44.163993
8	5	10	2025-11-03 10:08:44.166329	2025-11-03 10:08:44.166329
9	6	3	2025-11-03 10:10:42.367722	2025-11-03 10:10:42.367722
10	6	7	2025-11-03 10:10:42.370324	2025-11-03 10:10:42.370324
11	7	4	2025-11-03 10:12:43.909509	2025-11-03 10:12:43.909509
12	8	1	2025-11-03 10:14:14.743895	2025-11-03 10:14:14.743895
13	8	8	2025-11-03 10:14:14.745994	2025-11-03 10:14:14.745994
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies (id, title, description, poster_image, release_date, duration, rating, deleted_at, created_at, updated_at) FROM stdin;
1	Inception	A skilled thief steals secrets from deep within the subconscious during dream states.	m1.png	2010-07-16	148	4.5	\N	2025-11-03 09:39:41.152378	2025-11-03 09:39:41.152378
3	Legacy of Time	A time-traveling agent must prevent a future war by fixing a single event in the past, but altering history comes at a cost.	m1.png	2025-01-12	134	4.2	\N	2025-11-03 10:06:38.484997	2025-11-03 10:06:38.484997
5	Rise of the Guardians: Reborn	Jack Frost must unite the Guardians once more to stop a dark entity feeding on children’s dreams.	m1.png	2025-05-25	106	4.2	\N	2025-11-03 10:08:44.154975	2025-11-03 10:08:44.154975
6	Midnight Masala	Two rival food-truck owners in Mumbai must team up for a city-wide culinary contest — and fall unexpectedly in love	m1.png	2025-12-12	118	3.8	\N	2025-11-03 10:10:42.353335	2025-11-03 10:10:42.353335
7	Echoes of Home	A celebrated singer returns to her village to care for her aging father, reigniting local traditions and a long-lost duet.	m1.png	2025-12-18	142	3.8	\N	2025-11-03 10:12:43.895035	2025-11-03 10:12:43.895035
8	The Last Ember	An ex-operatives team races against a private militia to recover a stolen experimental energy source before it destabilizes a continent.	m1.png	2025-12-28	142	4.2	\N	2025-11-03 10:14:14.730666	2025-11-03 10:14:14.730666
2	Avengers: Endgame	After the events of Infinity War, the remaining Avengers assemble to reverse Thanos' actions.	m1.png	2019-04-26	181	4.6	\N	2025-11-03 09:39:41.156422	2025-11-03 10:15:03.674224
4	Quantum Heist	A team of hackers attempts the biggest digital bank heist in history using quantum computing — until one of them betrays the plan.	m1.png	2025-03-07	129	4.1	\N	2025-11-03 10:07:38.404403	2025-11-04 05:37:18.90401
\.


--
-- Data for Name: movies_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies_tags (movie_id, tag_id) FROM stdin;
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservations (id, user_id, showtime_id, seats_count, total_amount, payment_status, deleted_at, created_at, updated_at, txnid) FROM stdin;
1	1	1	0	150.0	success	\N	2025-11-03 09:55:49.197341	2025-11-03 09:56:44.734309	TXN17621637491794201
3	2	1	0	150.0	success	\N	2025-11-03 10:02:32.654199	2025-11-03 10:03:09.110038	TXN17621641526443243
4	2	2	0	150.0	success	\N	2025-11-07 06:39:14.078304	2025-11-07 06:40:00.01428	TXN1762497554716787
5	8	3	0	150.0	pending	\N	2025-11-07 07:18:48.09537	2025-11-07 07:18:48.09537	TXN1762499928873883
6	8	2	0	150.0	pending	\N	2025-11-07 07:19:39.882621	2025-11-07 07:19:39.882621	TXN17624999798734668
8	8	2	0	150.0	pending	\N	2025-11-07 07:23:10.883488	2025-11-07 07:23:10.883488	TXN17625001908746158
9	8	2	0	150.0	success	\N	2025-11-07 08:00:01.961086	2025-11-07 08:01:32.311795	TXN17625024019559026
7	8	3	0	150.0	pending	2025-11-07 08:28:25.275363	2025-11-07 07:21:37.368108	2025-11-07 08:28:25.276888	TXN17625000973615460
10	8	2	0	150.0	success	\N	2025-11-07 08:29:17.211821	2025-11-07 08:30:08.600679	TXN17625041572036014
11	1	2	0	150.0	success	\N	2025-11-07 09:35:14.724347	2025-11-07 09:36:08.07627	TXN17625081147041611
12	1	3	0	150.0	success	\N	2025-11-07 10:13:06.394388	2025-11-07 10:13:48.368005	TXN17625103863762136
18	1	2	0	150.0	success	\N	2025-11-07 10:32:05.092836	2025-11-07 10:32:45.612192	TXN1762511525248775
22	1	2	0	150.0	pending	\N	2025-11-07 10:44:28.231125	2025-11-07 10:44:28.231125	TXN17625122682146927
25	1	2	0	150.0	success	\N	2025-11-07 10:50:35.332317	2025-11-07 10:51:18.612731	TXN17625126353197394
26	2	3	0	150.0	success	\N	2025-11-07 10:52:17.455311	2025-11-07 10:53:23.777535	TXN17625127374506378
2	2	1	0	150.0	success	2025-11-07 10:53:57.028854	2025-11-03 09:59:48.041406	2025-11-07 10:53:57.029073	TXN1762163988367864
\.


--
-- Data for Name: reservations_seats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservations_seats (reservation_id, seat_id) FROM stdin;
1	1
2	9
3	2
4	201
5	202
6	202
7	202
8	219
9	204
10	350
22	237
25	201
26	201
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20250930071627
20250930072401
20250930083707
20250930083916
20250930095144
20250930110443
20251003041645
20251004144949
20251008093435
20251009041632
20251009043634
20251009102906
20251009140143
20251010065342
20251013054012
20251023154655
20251023165603
20251029090656
20251103044927
20251107085923
\.


--
-- Data for Name: screens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.screens (id, theatre_id, name, total_seats, screen_type, deleted_at, created_at, updated_at) FROM stdin;
1	1	Screen 1	200	2D	\N	2025-11-03 09:39:41.168421	2025-11-03 09:39:41.168421
2	2	Screen 2	150	3D	\N	2025-11-03 09:39:41.402766	2025-11-03 09:39:41.402766
\.


--
-- Data for Name: seats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seats (id, screen_id, "row", seat_number, seat_type, price, available, deleted_at, created_at, updated_at) FROM stdin;
201	2	A	1	Regular	150.0	f	\N	2025-11-03 09:39:41.404955	2025-11-07 06:40:00.020282
1	1	A	1	Regular	150.0	f	\N	2025-11-03 09:39:41.177178	2025-11-03 09:56:44.745952
9	1	B	1	Regular	150.0	f	\N	2025-11-03 09:39:41.188395	2025-11-03 10:00:17.540377
2	1	A	2	Regular	150.0	f	\N	2025-11-03 09:39:41.181271	2025-11-03 10:03:09.121966
3	1	A	3	Regular	150.0	t	\N	2025-11-03 09:39:41.1824	2025-11-03 09:39:41.1824
4	1	A	4	Regular	150.0	t	\N	2025-11-03 09:39:41.183343	2025-11-03 09:39:41.183343
5	1	A	5	Regular	150.0	t	\N	2025-11-03 09:39:41.184479	2025-11-03 09:39:41.184479
6	1	A	6	Regular	150.0	t	\N	2025-11-03 09:39:41.185433	2025-11-03 09:39:41.185433
7	1	A	7	Regular	150.0	t	\N	2025-11-03 09:39:41.186355	2025-11-03 09:39:41.186355
8	1	A	8	Regular	150.0	t	\N	2025-11-03 09:39:41.187216	2025-11-03 09:39:41.187216
10	1	B	2	Regular	150.0	t	\N	2025-11-03 09:39:41.189319	2025-11-03 09:39:41.189319
11	1	B	3	Regular	150.0	t	\N	2025-11-03 09:39:41.190142	2025-11-03 09:39:41.190142
12	1	B	4	Regular	150.0	t	\N	2025-11-03 09:39:41.191158	2025-11-03 09:39:41.191158
13	1	B	5	Regular	150.0	t	\N	2025-11-03 09:39:41.192072	2025-11-03 09:39:41.192072
14	1	B	6	Regular	150.0	t	\N	2025-11-03 09:39:41.192885	2025-11-03 09:39:41.192885
15	1	B	7	Regular	150.0	t	\N	2025-11-03 09:39:41.193684	2025-11-03 09:39:41.193684
16	1	B	8	Regular	150.0	t	\N	2025-11-03 09:39:41.194859	2025-11-03 09:39:41.194859
17	1	C	1	Regular	150.0	t	\N	2025-11-03 09:39:41.195712	2025-11-03 09:39:41.195712
18	1	C	2	Regular	150.0	t	\N	2025-11-03 09:39:41.196481	2025-11-03 09:39:41.196481
19	1	C	3	Regular	150.0	t	\N	2025-11-03 09:39:41.197462	2025-11-03 09:39:41.197462
20	1	C	4	Regular	150.0	t	\N	2025-11-03 09:39:41.198305	2025-11-03 09:39:41.198305
21	1	C	5	Regular	150.0	t	\N	2025-11-03 09:39:41.19912	2025-11-03 09:39:41.19912
22	1	C	6	Regular	150.0	t	\N	2025-11-03 09:39:41.199924	2025-11-03 09:39:41.199924
23	1	C	7	Regular	150.0	t	\N	2025-11-03 09:39:41.200897	2025-11-03 09:39:41.200897
24	1	C	8	Regular	150.0	t	\N	2025-11-03 09:39:41.20192	2025-11-03 09:39:41.20192
25	1	D	1	Regular	150.0	t	\N	2025-11-03 09:39:41.202794	2025-11-03 09:39:41.202794
26	1	D	2	Regular	150.0	t	\N	2025-11-03 09:39:41.203569	2025-11-03 09:39:41.203569
27	1	D	3	Regular	150.0	t	\N	2025-11-03 09:39:41.204541	2025-11-03 09:39:41.204541
28	1	D	4	Regular	150.0	t	\N	2025-11-03 09:39:41.205408	2025-11-03 09:39:41.205408
29	1	D	5	Regular	150.0	t	\N	2025-11-03 09:39:41.206211	2025-11-03 09:39:41.206211
30	1	D	6	Regular	150.0	t	\N	2025-11-03 09:39:41.207098	2025-11-03 09:39:41.207098
31	1	D	7	Regular	150.0	t	\N	2025-11-03 09:39:41.208006	2025-11-03 09:39:41.208006
32	1	D	8	Regular	150.0	t	\N	2025-11-03 09:39:41.20905	2025-11-03 09:39:41.20905
33	1	E	1	Regular	150.0	t	\N	2025-11-03 09:39:41.209865	2025-11-03 09:39:41.209865
34	1	E	2	Regular	150.0	t	\N	2025-11-03 09:39:41.210635	2025-11-03 09:39:41.210635
35	1	E	3	Regular	150.0	t	\N	2025-11-03 09:39:41.211563	2025-11-03 09:39:41.211563
36	1	E	4	Regular	150.0	t	\N	2025-11-03 09:39:41.212366	2025-11-03 09:39:41.212366
37	1	E	5	Regular	150.0	t	\N	2025-11-03 09:39:41.213169	2025-11-03 09:39:41.213169
38	1	E	6	Regular	150.0	t	\N	2025-11-03 09:39:41.213975	2025-11-03 09:39:41.213975
39	1	E	7	Regular	150.0	t	\N	2025-11-03 09:39:41.214762	2025-11-03 09:39:41.214762
40	1	E	8	Regular	150.0	t	\N	2025-11-03 09:39:41.215728	2025-11-03 09:39:41.215728
41	1	F	1	Regular	150.0	t	\N	2025-11-03 09:39:41.216631	2025-11-03 09:39:41.216631
42	1	F	2	Regular	150.0	t	\N	2025-11-03 09:39:41.217498	2025-11-03 09:39:41.217498
43	1	F	3	Regular	150.0	t	\N	2025-11-03 09:39:41.218354	2025-11-03 09:39:41.218354
44	1	F	4	Regular	150.0	t	\N	2025-11-03 09:39:41.219254	2025-11-03 09:39:41.219254
45	1	F	5	Regular	150.0	t	\N	2025-11-03 09:39:41.220056	2025-11-03 09:39:41.220056
46	1	F	6	Regular	150.0	t	\N	2025-11-03 09:39:41.221779	2025-11-03 09:39:41.221779
47	1	F	7	Regular	150.0	t	\N	2025-11-03 09:39:41.222877	2025-11-03 09:39:41.222877
48	1	F	8	Regular	150.0	t	\N	2025-11-03 09:39:41.223748	2025-11-03 09:39:41.223748
49	1	G	1	Regular	150.0	t	\N	2025-11-03 09:39:41.224738	2025-11-03 09:39:41.224738
50	1	G	2	Regular	150.0	t	\N	2025-11-03 09:39:41.225593	2025-11-03 09:39:41.225593
51	1	G	3	Regular	150.0	t	\N	2025-11-03 09:39:41.226446	2025-11-03 09:39:41.226446
52	1	G	4	Regular	150.0	t	\N	2025-11-03 09:39:41.227434	2025-11-03 09:39:41.227434
53	1	G	5	Regular	150.0	t	\N	2025-11-03 09:39:41.228761	2025-11-03 09:39:41.228761
54	1	G	6	Regular	150.0	t	\N	2025-11-03 09:39:41.229782	2025-11-03 09:39:41.229782
55	1	G	7	Regular	150.0	t	\N	2025-11-03 09:39:41.230851	2025-11-03 09:39:41.230851
56	1	G	8	Regular	150.0	t	\N	2025-11-03 09:39:41.232038	2025-11-03 09:39:41.232038
57	1	H	1	Regular	150.0	t	\N	2025-11-03 09:39:41.233066	2025-11-03 09:39:41.233066
58	1	H	2	Regular	150.0	t	\N	2025-11-03 09:39:41.234023	2025-11-03 09:39:41.234023
59	1	H	3	Regular	150.0	t	\N	2025-11-03 09:39:41.234985	2025-11-03 09:39:41.234985
60	1	H	4	Regular	150.0	t	\N	2025-11-03 09:39:41.236181	2025-11-03 09:39:41.236181
61	1	H	5	Regular	150.0	t	\N	2025-11-03 09:39:41.237142	2025-11-03 09:39:41.237142
62	1	H	6	Regular	150.0	t	\N	2025-11-03 09:39:41.238081	2025-11-03 09:39:41.238081
63	1	H	7	Regular	150.0	t	\N	2025-11-03 09:39:41.239084	2025-11-03 09:39:41.239084
64	1	H	8	Regular	150.0	t	\N	2025-11-03 09:39:41.239944	2025-11-03 09:39:41.239944
65	1	I	1	Regular	150.0	t	\N	2025-11-03 09:39:41.240739	2025-11-03 09:39:41.240739
66	1	I	2	Regular	150.0	t	\N	2025-11-03 09:39:41.241551	2025-11-03 09:39:41.241551
67	1	I	3	Regular	150.0	t	\N	2025-11-03 09:39:41.242474	2025-11-03 09:39:41.242474
68	1	I	4	Regular	150.0	t	\N	2025-11-03 09:39:41.243464	2025-11-03 09:39:41.243464
69	1	I	5	Regular	150.0	t	\N	2025-11-03 09:39:41.244367	2025-11-03 09:39:41.244367
70	1	I	6	Regular	150.0	t	\N	2025-11-03 09:39:41.245243	2025-11-03 09:39:41.245243
71	1	I	7	Regular	150.0	t	\N	2025-11-03 09:39:41.246177	2025-11-03 09:39:41.246177
72	1	I	8	Regular	150.0	t	\N	2025-11-03 09:39:41.247107	2025-11-03 09:39:41.247107
73	1	J	1	Regular	150.0	t	\N	2025-11-03 09:39:41.248021	2025-11-03 09:39:41.248021
74	1	J	2	Regular	150.0	t	\N	2025-11-03 09:39:41.248848	2025-11-03 09:39:41.248848
75	1	J	3	Regular	150.0	t	\N	2025-11-03 09:39:41.249893	2025-11-03 09:39:41.249893
76	1	J	4	Regular	150.0	t	\N	2025-11-03 09:39:41.25094	2025-11-03 09:39:41.25094
77	1	J	5	Regular	150.0	t	\N	2025-11-03 09:39:41.251781	2025-11-03 09:39:41.251781
78	1	J	6	Regular	150.0	t	\N	2025-11-03 09:39:41.252552	2025-11-03 09:39:41.252552
79	1	J	7	Regular	150.0	t	\N	2025-11-03 09:39:41.253344	2025-11-03 09:39:41.253344
80	1	J	8	Regular	150.0	t	\N	2025-11-03 09:39:41.254125	2025-11-03 09:39:41.254125
81	1	K	1	Regular	150.0	t	\N	2025-11-03 09:39:41.254948	2025-11-03 09:39:41.254948
82	1	K	2	Regular	150.0	t	\N	2025-11-03 09:39:41.255747	2025-11-03 09:39:41.255747
83	1	K	3	Regular	150.0	t	\N	2025-11-03 09:39:41.25658	2025-11-03 09:39:41.25658
84	1	K	4	Regular	150.0	t	\N	2025-11-03 09:39:41.257562	2025-11-03 09:39:41.257562
85	1	K	5	Regular	150.0	t	\N	2025-11-03 09:39:41.258456	2025-11-03 09:39:41.258456
86	1	K	6	Regular	150.0	t	\N	2025-11-03 09:39:41.259268	2025-11-03 09:39:41.259268
87	1	K	7	Regular	150.0	t	\N	2025-11-03 09:39:41.260086	2025-11-03 09:39:41.260086
88	1	K	8	Regular	150.0	t	\N	2025-11-03 09:39:41.260928	2025-11-03 09:39:41.260928
89	1	L	1	Regular	150.0	t	\N	2025-11-03 09:39:41.26267	2025-11-03 09:39:41.26267
90	1	L	2	Regular	150.0	t	\N	2025-11-03 09:39:41.263604	2025-11-03 09:39:41.263604
91	1	L	3	Regular	150.0	t	\N	2025-11-03 09:39:41.264552	2025-11-03 09:39:41.264552
92	1	L	4	Regular	150.0	t	\N	2025-11-03 09:39:41.265367	2025-11-03 09:39:41.265367
93	1	L	5	Regular	150.0	t	\N	2025-11-03 09:39:41.266438	2025-11-03 09:39:41.266438
94	1	L	6	Regular	150.0	t	\N	2025-11-03 09:39:41.267245	2025-11-03 09:39:41.267245
95	1	L	7	Regular	150.0	t	\N	2025-11-03 09:39:41.26805	2025-11-03 09:39:41.26805
96	1	L	8	Regular	150.0	t	\N	2025-11-03 09:39:41.269113	2025-11-03 09:39:41.269113
97	1	M	1	Regular	150.0	t	\N	2025-11-03 09:39:41.27002	2025-11-03 09:39:41.27002
98	1	M	2	Regular	150.0	t	\N	2025-11-03 09:39:41.270951	2025-11-03 09:39:41.270951
99	1	M	3	Regular	150.0	t	\N	2025-11-03 09:39:41.271944	2025-11-03 09:39:41.271944
100	1	M	4	Regular	150.0	t	\N	2025-11-03 09:39:41.272989	2025-11-03 09:39:41.272989
101	1	M	5	Regular	150.0	t	\N	2025-11-03 09:39:41.273877	2025-11-03 09:39:41.273877
102	1	M	6	Regular	150.0	t	\N	2025-11-03 09:39:41.274654	2025-11-03 09:39:41.274654
103	1	M	7	Regular	150.0	t	\N	2025-11-03 09:39:41.275483	2025-11-03 09:39:41.275483
104	1	M	8	Regular	150.0	t	\N	2025-11-03 09:39:41.276492	2025-11-03 09:39:41.276492
105	1	N	1	Regular	150.0	t	\N	2025-11-03 09:39:41.277392	2025-11-03 09:39:41.277392
106	1	N	2	Regular	150.0	t	\N	2025-11-03 09:39:41.27852	2025-11-03 09:39:41.27852
107	1	N	3	Regular	150.0	t	\N	2025-11-03 09:39:41.279608	2025-11-03 09:39:41.279608
108	1	N	4	Regular	150.0	t	\N	2025-11-03 09:39:41.28067	2025-11-03 09:39:41.28067
109	1	N	5	Regular	150.0	t	\N	2025-11-03 09:39:41.281524	2025-11-03 09:39:41.281524
110	1	N	6	Regular	150.0	t	\N	2025-11-03 09:39:41.282367	2025-11-03 09:39:41.282367
111	1	N	7	Regular	150.0	t	\N	2025-11-03 09:39:41.283232	2025-11-03 09:39:41.283232
112	1	N	8	Regular	150.0	t	\N	2025-11-03 09:39:41.284211	2025-11-03 09:39:41.284211
113	1	O	1	Regular	150.0	t	\N	2025-11-03 09:39:41.285144	2025-11-03 09:39:41.285144
114	1	O	2	Regular	150.0	t	\N	2025-11-03 09:39:41.286188	2025-11-03 09:39:41.286188
115	1	O	3	Regular	150.0	t	\N	2025-11-03 09:39:41.287096	2025-11-03 09:39:41.287096
116	1	O	4	Regular	150.0	t	\N	2025-11-03 09:39:41.288272	2025-11-03 09:39:41.288272
117	1	O	5	Regular	150.0	t	\N	2025-11-03 09:39:41.28919	2025-11-03 09:39:41.28919
118	1	O	6	Regular	150.0	t	\N	2025-11-03 09:39:41.290007	2025-11-03 09:39:41.290007
119	1	O	7	Regular	150.0	t	\N	2025-11-03 09:39:41.290822	2025-11-03 09:39:41.290822
120	1	O	8	Regular	150.0	t	\N	2025-11-03 09:39:41.291632	2025-11-03 09:39:41.291632
121	1	P	1	Regular	150.0	t	\N	2025-11-03 09:39:41.292823	2025-11-03 09:39:41.292823
122	1	P	2	Regular	150.0	t	\N	2025-11-03 09:39:41.293683	2025-11-03 09:39:41.293683
123	1	P	3	Regular	150.0	t	\N	2025-11-03 09:39:41.294475	2025-11-03 09:39:41.294475
124	1	P	4	Regular	150.0	t	\N	2025-11-03 09:39:41.295316	2025-11-03 09:39:41.295316
125	1	P	5	Regular	150.0	t	\N	2025-11-03 09:39:41.296161	2025-11-03 09:39:41.296161
126	1	P	6	Regular	150.0	t	\N	2025-11-03 09:39:41.296977	2025-11-03 09:39:41.296977
127	1	P	7	Regular	150.0	t	\N	2025-11-03 09:39:41.29795	2025-11-03 09:39:41.29795
128	1	P	8	Regular	150.0	t	\N	2025-11-03 09:39:41.298988	2025-11-03 09:39:41.298988
129	1	Q	1	Regular	150.0	t	\N	2025-11-03 09:39:41.300035	2025-11-03 09:39:41.300035
130	1	Q	2	Regular	150.0	t	\N	2025-11-03 09:39:41.300928	2025-11-03 09:39:41.300928
131	1	Q	3	Regular	150.0	t	\N	2025-11-03 09:39:41.301767	2025-11-03 09:39:41.301767
132	1	Q	4	Regular	150.0	t	\N	2025-11-03 09:39:41.303574	2025-11-03 09:39:41.303574
133	1	Q	5	Regular	150.0	t	\N	2025-11-03 09:39:41.304529	2025-11-03 09:39:41.304529
134	1	Q	6	Regular	150.0	t	\N	2025-11-03 09:39:41.305346	2025-11-03 09:39:41.305346
135	1	Q	7	Regular	150.0	t	\N	2025-11-03 09:39:41.30624	2025-11-03 09:39:41.30624
136	1	Q	8	Regular	150.0	t	\N	2025-11-03 09:39:41.307481	2025-11-03 09:39:41.307481
137	1	R	1	Regular	150.0	t	\N	2025-11-03 09:39:41.308301	2025-11-03 09:39:41.308301
138	1	R	2	Regular	150.0	t	\N	2025-11-03 09:39:41.309145	2025-11-03 09:39:41.309145
139	1	R	3	Regular	150.0	t	\N	2025-11-03 09:39:41.31019	2025-11-03 09:39:41.31019
140	1	R	4	Regular	150.0	t	\N	2025-11-03 09:39:41.311092	2025-11-03 09:39:41.311092
141	1	R	5	Regular	150.0	t	\N	2025-11-03 09:39:41.311885	2025-11-03 09:39:41.311885
142	1	R	6	Regular	150.0	t	\N	2025-11-03 09:39:41.312683	2025-11-03 09:39:41.312683
143	1	R	7	Regular	150.0	t	\N	2025-11-03 09:39:41.313864	2025-11-03 09:39:41.313864
144	1	R	8	Regular	150.0	t	\N	2025-11-03 09:39:41.315026	2025-11-03 09:39:41.315026
145	1	S	1	Regular	150.0	t	\N	2025-11-03 09:39:41.316023	2025-11-03 09:39:41.316023
146	1	S	2	Regular	150.0	t	\N	2025-11-03 09:39:41.316946	2025-11-03 09:39:41.316946
147	1	S	3	Regular	150.0	t	\N	2025-11-03 09:39:41.318003	2025-11-03 09:39:41.318003
148	1	S	4	Regular	150.0	t	\N	2025-11-03 09:39:41.318914	2025-11-03 09:39:41.318914
149	1	S	5	Regular	150.0	t	\N	2025-11-03 09:39:41.319828	2025-11-03 09:39:41.319828
150	1	S	6	Regular	150.0	t	\N	2025-11-03 09:39:41.321276	2025-11-03 09:39:41.321276
151	1	S	7	Regular	150.0	t	\N	2025-11-03 09:39:41.3222	2025-11-03 09:39:41.3222
152	1	S	8	Regular	150.0	t	\N	2025-11-03 09:39:41.323019	2025-11-03 09:39:41.323019
153	1	T	1	Regular	150.0	t	\N	2025-11-03 09:39:41.323854	2025-11-03 09:39:41.323854
154	1	T	2	Regular	150.0	t	\N	2025-11-03 09:39:41.324945	2025-11-03 09:39:41.324945
155	1	T	3	Regular	150.0	t	\N	2025-11-03 09:39:41.325877	2025-11-03 09:39:41.325877
156	1	T	4	Regular	150.0	t	\N	2025-11-03 09:39:41.326709	2025-11-03 09:39:41.326709
157	1	T	5	Regular	150.0	t	\N	2025-11-03 09:39:41.327627	2025-11-03 09:39:41.327627
158	1	T	6	Regular	150.0	t	\N	2025-11-03 09:39:41.328943	2025-11-03 09:39:41.328943
159	1	T	7	Regular	150.0	t	\N	2025-11-03 09:39:41.329978	2025-11-03 09:39:41.329978
160	1	T	8	Regular	150.0	t	\N	2025-11-03 09:39:41.330873	2025-11-03 09:39:41.330873
161	1	U	1	Regular	150.0	t	\N	2025-11-03 09:39:41.33176	2025-11-03 09:39:41.33176
162	1	U	2	Regular	150.0	t	\N	2025-11-03 09:39:41.332601	2025-11-03 09:39:41.332601
163	1	U	3	Regular	150.0	t	\N	2025-11-03 09:39:41.333656	2025-11-03 09:39:41.333656
164	1	U	4	Regular	150.0	t	\N	2025-11-03 09:39:41.334613	2025-11-03 09:39:41.334613
165	1	U	5	Regular	150.0	t	\N	2025-11-03 09:39:41.335465	2025-11-03 09:39:41.335465
166	1	U	6	Regular	150.0	t	\N	2025-11-03 09:39:41.336397	2025-11-03 09:39:41.336397
167	1	U	7	Regular	150.0	t	\N	2025-11-03 09:39:41.337452	2025-11-03 09:39:41.337452
168	1	U	8	Regular	150.0	t	\N	2025-11-03 09:39:41.342131	2025-11-03 09:39:41.342131
169	1	V	1	Regular	150.0	t	\N	2025-11-03 09:39:41.356679	2025-11-03 09:39:41.356679
170	1	V	2	Regular	150.0	t	\N	2025-11-03 09:39:41.364128	2025-11-03 09:39:41.364128
171	1	V	3	Regular	150.0	t	\N	2025-11-03 09:39:41.365251	2025-11-03 09:39:41.365251
172	1	V	4	Regular	150.0	t	\N	2025-11-03 09:39:41.36618	2025-11-03 09:39:41.36618
173	1	V	5	Regular	150.0	t	\N	2025-11-03 09:39:41.367339	2025-11-03 09:39:41.367339
174	1	V	6	Regular	150.0	t	\N	2025-11-03 09:39:41.368277	2025-11-03 09:39:41.368277
175	1	V	7	Regular	150.0	t	\N	2025-11-03 09:39:41.369275	2025-11-03 09:39:41.369275
176	1	V	8	Regular	150.0	t	\N	2025-11-03 09:39:41.370175	2025-11-03 09:39:41.370175
177	1	W	1	Regular	150.0	t	\N	2025-11-03 09:39:41.371314	2025-11-03 09:39:41.371314
178	1	W	2	Regular	150.0	t	\N	2025-11-03 09:39:41.372204	2025-11-03 09:39:41.372204
179	1	W	3	Regular	150.0	t	\N	2025-11-03 09:39:41.373019	2025-11-03 09:39:41.373019
180	1	W	4	Regular	150.0	t	\N	2025-11-03 09:39:41.373818	2025-11-03 09:39:41.373818
181	1	W	5	Regular	150.0	t	\N	2025-11-03 09:39:41.374805	2025-11-03 09:39:41.374805
182	1	W	6	Regular	150.0	t	\N	2025-11-03 09:39:41.375708	2025-11-03 09:39:41.375708
183	1	W	7	Regular	150.0	t	\N	2025-11-03 09:39:41.376669	2025-11-03 09:39:41.376669
184	1	W	8	Regular	150.0	t	\N	2025-11-03 09:39:41.377653	2025-11-03 09:39:41.377653
185	1	X	1	Regular	150.0	t	\N	2025-11-03 09:39:41.378845	2025-11-03 09:39:41.378845
186	1	X	2	Regular	150.0	t	\N	2025-11-03 09:39:41.379811	2025-11-03 09:39:41.379811
187	1	X	3	Regular	150.0	t	\N	2025-11-03 09:39:41.380697	2025-11-03 09:39:41.380697
188	1	X	4	Regular	150.0	t	\N	2025-11-03 09:39:41.381724	2025-11-03 09:39:41.381724
189	1	X	5	Regular	150.0	t	\N	2025-11-03 09:39:41.38276	2025-11-03 09:39:41.38276
190	1	X	6	Regular	150.0	t	\N	2025-11-03 09:39:41.383714	2025-11-03 09:39:41.383714
191	1	X	7	Regular	150.0	t	\N	2025-11-03 09:39:41.384496	2025-11-03 09:39:41.384496
192	1	X	8	Regular	150.0	t	\N	2025-11-03 09:39:41.385673	2025-11-03 09:39:41.385673
193	1	Y	1	Regular	150.0	t	\N	2025-11-03 09:39:41.386516	2025-11-03 09:39:41.386516
194	1	Y	2	Regular	150.0	t	\N	2025-11-03 09:39:41.387353	2025-11-03 09:39:41.387353
195	1	Y	3	Regular	150.0	t	\N	2025-11-03 09:39:41.388305	2025-11-03 09:39:41.388305
196	1	Y	4	Regular	150.0	t	\N	2025-11-03 09:39:41.389484	2025-11-03 09:39:41.389484
197	1	Y	5	Regular	150.0	t	\N	2025-11-03 09:39:41.390535	2025-11-03 09:39:41.390535
198	1	Y	6	Regular	150.0	t	\N	2025-11-03 09:39:41.391627	2025-11-03 09:39:41.391627
199	1	Y	7	Regular	150.0	t	\N	2025-11-03 09:39:41.392628	2025-11-03 09:39:41.392628
200	1	Y	8	Regular	150.0	t	\N	2025-11-03 09:39:41.39375	2025-11-03 09:39:41.39375
203	2	A	3	Regular	150.0	t	\N	2025-11-03 09:39:41.40719	2025-11-03 09:39:41.40719
205	2	A	5	Regular	150.0	t	\N	2025-11-03 09:39:41.408911	2025-11-03 09:39:41.408911
206	2	A	6	Regular	150.0	t	\N	2025-11-03 09:39:41.409728	2025-11-03 09:39:41.409728
207	2	B	1	Regular	150.0	t	\N	2025-11-03 09:39:41.410516	2025-11-03 09:39:41.410516
208	2	B	2	Regular	150.0	t	\N	2025-11-03 09:39:41.411438	2025-11-03 09:39:41.411438
209	2	B	3	Regular	150.0	t	\N	2025-11-03 09:39:41.413387	2025-11-03 09:39:41.413387
210	2	B	4	Regular	150.0	t	\N	2025-11-03 09:39:41.414262	2025-11-03 09:39:41.414262
204	2	A	4	Regular	150.0	f	\N	2025-11-03 09:39:41.408066	2025-11-07 08:01:32.32862
202	2	A	2	Regular	150.0	t	\N	2025-11-03 09:39:41.406019	2025-11-03 09:39:41.406019
211	2	B	5	Regular	150.0	t	\N	2025-11-03 09:39:41.415104	2025-11-03 09:39:41.415104
212	2	B	6	Regular	150.0	t	\N	2025-11-03 09:39:41.415934	2025-11-03 09:39:41.415934
213	2	C	1	Regular	150.0	t	\N	2025-11-03 09:39:41.417062	2025-11-03 09:39:41.417062
214	2	C	2	Regular	150.0	t	\N	2025-11-03 09:39:41.417863	2025-11-03 09:39:41.417863
215	2	C	3	Regular	150.0	t	\N	2025-11-03 09:39:41.41881	2025-11-03 09:39:41.41881
216	2	C	4	Regular	150.0	t	\N	2025-11-03 09:39:41.419914	2025-11-03 09:39:41.419914
217	2	C	5	Regular	150.0	t	\N	2025-11-03 09:39:41.420826	2025-11-03 09:39:41.420826
218	2	C	6	Regular	150.0	t	\N	2025-11-03 09:39:41.421615	2025-11-03 09:39:41.421615
219	2	D	1	Regular	150.0	t	\N	2025-11-03 09:39:41.422515	2025-11-03 09:39:41.422515
220	2	D	2	Regular	150.0	t	\N	2025-11-03 09:39:41.423599	2025-11-03 09:39:41.423599
221	2	D	3	Regular	150.0	t	\N	2025-11-03 09:39:41.424407	2025-11-03 09:39:41.424407
222	2	D	4	Regular	150.0	t	\N	2025-11-03 09:39:41.425324	2025-11-03 09:39:41.425324
223	2	D	5	Regular	150.0	t	\N	2025-11-03 09:39:41.426367	2025-11-03 09:39:41.426367
224	2	D	6	Regular	150.0	t	\N	2025-11-03 09:39:41.427253	2025-11-03 09:39:41.427253
225	2	E	1	Regular	150.0	t	\N	2025-11-03 09:39:41.428102	2025-11-03 09:39:41.428102
226	2	E	2	Regular	150.0	t	\N	2025-11-03 09:39:41.429038	2025-11-03 09:39:41.429038
227	2	E	3	Regular	150.0	t	\N	2025-11-03 09:39:41.430268	2025-11-03 09:39:41.430268
228	2	E	4	Regular	150.0	t	\N	2025-11-03 09:39:41.431143	2025-11-03 09:39:41.431143
229	2	E	5	Regular	150.0	t	\N	2025-11-03 09:39:41.432027	2025-11-03 09:39:41.432027
230	2	E	6	Regular	150.0	t	\N	2025-11-03 09:39:41.433227	2025-11-03 09:39:41.433227
231	2	F	1	Regular	150.0	t	\N	2025-11-03 09:39:41.434306	2025-11-03 09:39:41.434306
232	2	F	2	Regular	150.0	t	\N	2025-11-03 09:39:41.435184	2025-11-03 09:39:41.435184
233	2	F	3	Regular	150.0	t	\N	2025-11-03 09:39:41.435988	2025-11-03 09:39:41.435988
234	2	F	4	Regular	150.0	t	\N	2025-11-03 09:39:41.436778	2025-11-03 09:39:41.436778
235	2	F	5	Regular	150.0	t	\N	2025-11-03 09:39:41.437566	2025-11-03 09:39:41.437566
236	2	F	6	Regular	150.0	t	\N	2025-11-03 09:39:41.438372	2025-11-03 09:39:41.438372
237	2	G	1	Regular	150.0	t	\N	2025-11-03 09:39:41.439513	2025-11-03 09:39:41.439513
238	2	G	2	Regular	150.0	t	\N	2025-11-03 09:39:41.440413	2025-11-03 09:39:41.440413
239	2	G	3	Regular	150.0	t	\N	2025-11-03 09:39:41.441224	2025-11-03 09:39:41.441224
240	2	G	4	Regular	150.0	t	\N	2025-11-03 09:39:41.442005	2025-11-03 09:39:41.442005
241	2	G	5	Regular	150.0	t	\N	2025-11-03 09:39:41.443056	2025-11-03 09:39:41.443056
242	2	G	6	Regular	150.0	t	\N	2025-11-03 09:39:41.443973	2025-11-03 09:39:41.443973
243	2	H	1	Regular	150.0	t	\N	2025-11-03 09:39:41.444767	2025-11-03 09:39:41.444767
244	2	H	2	Regular	150.0	t	\N	2025-11-03 09:39:41.445564	2025-11-03 09:39:41.445564
245	2	H	3	Regular	150.0	t	\N	2025-11-03 09:39:41.446639	2025-11-03 09:39:41.446639
246	2	H	4	Regular	150.0	t	\N	2025-11-03 09:39:41.447498	2025-11-03 09:39:41.447498
247	2	H	5	Regular	150.0	t	\N	2025-11-03 09:39:41.448327	2025-11-03 09:39:41.448327
248	2	H	6	Regular	150.0	t	\N	2025-11-03 09:39:41.449166	2025-11-03 09:39:41.449166
249	2	I	1	Regular	150.0	t	\N	2025-11-03 09:39:41.449951	2025-11-03 09:39:41.449951
250	2	I	2	Regular	150.0	t	\N	2025-11-03 09:39:41.450727	2025-11-03 09:39:41.450727
251	2	I	3	Regular	150.0	t	\N	2025-11-03 09:39:41.451582	2025-11-03 09:39:41.451582
252	2	I	4	Regular	150.0	t	\N	2025-11-03 09:39:41.45238	2025-11-03 09:39:41.45238
253	2	I	5	Regular	150.0	t	\N	2025-11-03 09:39:41.454503	2025-11-03 09:39:41.454503
254	2	I	6	Regular	150.0	t	\N	2025-11-03 09:39:41.455716	2025-11-03 09:39:41.455716
255	2	J	1	Regular	150.0	t	\N	2025-11-03 09:39:41.456707	2025-11-03 09:39:41.456707
256	2	J	2	Regular	150.0	t	\N	2025-11-03 09:39:41.457815	2025-11-03 09:39:41.457815
257	2	J	3	Regular	150.0	t	\N	2025-11-03 09:39:41.458728	2025-11-03 09:39:41.458728
258	2	J	4	Regular	150.0	t	\N	2025-11-03 09:39:41.459686	2025-11-03 09:39:41.459686
259	2	J	5	Regular	150.0	t	\N	2025-11-03 09:39:41.460874	2025-11-03 09:39:41.460874
260	2	J	6	Regular	150.0	t	\N	2025-11-03 09:39:41.4621	2025-11-03 09:39:41.4621
261	2	K	1	Regular	150.0	t	\N	2025-11-03 09:39:41.463052	2025-11-03 09:39:41.463052
262	2	K	2	Regular	150.0	t	\N	2025-11-03 09:39:41.463918	2025-11-03 09:39:41.463918
263	2	K	3	Regular	150.0	t	\N	2025-11-03 09:39:41.464722	2025-11-03 09:39:41.464722
264	2	K	4	Regular	150.0	t	\N	2025-11-03 09:39:41.465862	2025-11-03 09:39:41.465862
265	2	K	5	Regular	150.0	t	\N	2025-11-03 09:39:41.466741	2025-11-03 09:39:41.466741
266	2	K	6	Regular	150.0	t	\N	2025-11-03 09:39:41.467729	2025-11-03 09:39:41.467729
267	2	L	1	Regular	150.0	t	\N	2025-11-03 09:39:41.468515	2025-11-03 09:39:41.468515
268	2	L	2	Regular	150.0	t	\N	2025-11-03 09:39:41.469562	2025-11-03 09:39:41.469562
269	2	L	3	Regular	150.0	t	\N	2025-11-03 09:39:41.470368	2025-11-03 09:39:41.470368
270	2	L	4	Regular	150.0	t	\N	2025-11-03 09:39:41.471191	2025-11-03 09:39:41.471191
271	2	L	5	Regular	150.0	t	\N	2025-11-03 09:39:41.472143	2025-11-03 09:39:41.472143
272	2	L	6	Regular	150.0	t	\N	2025-11-03 09:39:41.473027	2025-11-03 09:39:41.473027
273	2	M	1	Regular	150.0	t	\N	2025-11-03 09:39:41.473983	2025-11-03 09:39:41.473983
274	2	M	2	Regular	150.0	t	\N	2025-11-03 09:39:41.474854	2025-11-03 09:39:41.474854
275	2	M	3	Regular	150.0	t	\N	2025-11-03 09:39:41.475968	2025-11-03 09:39:41.475968
276	2	M	4	Regular	150.0	t	\N	2025-11-03 09:39:41.476784	2025-11-03 09:39:41.476784
277	2	M	5	Regular	150.0	t	\N	2025-11-03 09:39:41.477584	2025-11-03 09:39:41.477584
278	2	M	6	Regular	150.0	t	\N	2025-11-03 09:39:41.478528	2025-11-03 09:39:41.478528
279	2	N	1	Regular	150.0	t	\N	2025-11-03 09:39:41.479496	2025-11-03 09:39:41.479496
280	2	N	2	Regular	150.0	t	\N	2025-11-03 09:39:41.480445	2025-11-03 09:39:41.480445
281	2	N	3	Regular	150.0	t	\N	2025-11-03 09:39:41.481688	2025-11-03 09:39:41.481688
282	2	N	4	Regular	150.0	t	\N	2025-11-03 09:39:41.482867	2025-11-03 09:39:41.482867
283	2	N	5	Regular	150.0	t	\N	2025-11-03 09:39:41.483804	2025-11-03 09:39:41.483804
284	2	N	6	Regular	150.0	t	\N	2025-11-03 09:39:41.484692	2025-11-03 09:39:41.484692
285	2	O	1	Regular	150.0	t	\N	2025-11-03 09:39:41.485535	2025-11-03 09:39:41.485535
286	2	O	2	Regular	150.0	t	\N	2025-11-03 09:39:41.486383	2025-11-03 09:39:41.486383
287	2	O	3	Regular	150.0	t	\N	2025-11-03 09:39:41.487259	2025-11-03 09:39:41.487259
288	2	O	4	Regular	150.0	t	\N	2025-11-03 09:39:41.488131	2025-11-03 09:39:41.488131
289	2	O	5	Regular	150.0	t	\N	2025-11-03 09:39:41.489342	2025-11-03 09:39:41.489342
290	2	O	6	Regular	150.0	t	\N	2025-11-03 09:39:41.49024	2025-11-03 09:39:41.49024
291	2	P	1	Regular	150.0	t	\N	2025-11-03 09:39:41.491091	2025-11-03 09:39:41.491091
292	2	P	2	Regular	150.0	t	\N	2025-11-03 09:39:41.491897	2025-11-03 09:39:41.491897
293	2	P	3	Regular	150.0	t	\N	2025-11-03 09:39:41.492726	2025-11-03 09:39:41.492726
294	2	P	4	Regular	150.0	t	\N	2025-11-03 09:39:41.493553	2025-11-03 09:39:41.493553
295	2	P	5	Regular	150.0	t	\N	2025-11-03 09:39:41.494436	2025-11-03 09:39:41.494436
296	2	P	6	Regular	150.0	t	\N	2025-11-03 09:39:41.495611	2025-11-03 09:39:41.495611
297	2	Q	1	Regular	150.0	t	\N	2025-11-03 09:39:41.497605	2025-11-03 09:39:41.497605
298	2	Q	2	Regular	150.0	t	\N	2025-11-03 09:39:41.49852	2025-11-03 09:39:41.49852
299	2	Q	3	Regular	150.0	t	\N	2025-11-03 09:39:41.499354	2025-11-03 09:39:41.499354
300	2	Q	4	Regular	150.0	t	\N	2025-11-03 09:39:41.500206	2025-11-03 09:39:41.500206
301	2	Q	5	Regular	150.0	t	\N	2025-11-03 09:39:41.501338	2025-11-03 09:39:41.501338
302	2	Q	6	Regular	150.0	t	\N	2025-11-03 09:39:41.502298	2025-11-03 09:39:41.502298
303	2	R	1	Regular	150.0	t	\N	2025-11-03 09:39:41.503409	2025-11-03 09:39:41.503409
304	2	R	2	Regular	150.0	t	\N	2025-11-03 09:39:41.504604	2025-11-03 09:39:41.504604
305	2	R	3	Regular	150.0	t	\N	2025-11-03 09:39:41.505499	2025-11-03 09:39:41.505499
306	2	R	4	Regular	150.0	t	\N	2025-11-03 09:39:41.506321	2025-11-03 09:39:41.506321
307	2	R	5	Regular	150.0	t	\N	2025-11-03 09:39:41.507347	2025-11-03 09:39:41.507347
308	2	R	6	Regular	150.0	t	\N	2025-11-03 09:39:41.508231	2025-11-03 09:39:41.508231
309	2	S	1	Regular	150.0	t	\N	2025-11-03 09:39:41.509079	2025-11-03 09:39:41.509079
310	2	S	2	Regular	150.0	t	\N	2025-11-03 09:39:41.510072	2025-11-03 09:39:41.510072
311	2	S	3	Regular	150.0	t	\N	2025-11-03 09:39:41.511165	2025-11-03 09:39:41.511165
312	2	S	4	Regular	150.0	t	\N	2025-11-03 09:39:41.512085	2025-11-03 09:39:41.512085
313	2	S	5	Regular	150.0	t	\N	2025-11-03 09:39:41.512899	2025-11-03 09:39:41.512899
314	2	S	6	Regular	150.0	t	\N	2025-11-03 09:39:41.513686	2025-11-03 09:39:41.513686
315	2	T	1	Regular	150.0	t	\N	2025-11-03 09:39:41.514837	2025-11-03 09:39:41.514837
316	2	T	2	Regular	150.0	t	\N	2025-11-03 09:39:41.515909	2025-11-03 09:39:41.515909
317	2	T	3	Regular	150.0	t	\N	2025-11-03 09:39:41.517016	2025-11-03 09:39:41.517016
318	2	T	4	Regular	150.0	t	\N	2025-11-03 09:39:41.517864	2025-11-03 09:39:41.517864
319	2	T	5	Regular	150.0	t	\N	2025-11-03 09:39:41.518643	2025-11-03 09:39:41.518643
320	2	T	6	Regular	150.0	t	\N	2025-11-03 09:39:41.519474	2025-11-03 09:39:41.519474
321	2	U	1	Regular	150.0	t	\N	2025-11-03 09:39:41.520324	2025-11-03 09:39:41.520324
322	2	U	2	Regular	150.0	t	\N	2025-11-03 09:39:41.52112	2025-11-03 09:39:41.52112
323	2	U	3	Regular	150.0	t	\N	2025-11-03 09:39:41.522094	2025-11-03 09:39:41.522094
324	2	U	4	Regular	150.0	t	\N	2025-11-03 09:39:41.523018	2025-11-03 09:39:41.523018
325	2	U	5	Regular	150.0	t	\N	2025-11-03 09:39:41.523974	2025-11-03 09:39:41.523974
326	2	U	6	Regular	150.0	t	\N	2025-11-03 09:39:41.525048	2025-11-03 09:39:41.525048
327	2	V	1	Regular	150.0	t	\N	2025-11-03 09:39:41.526111	2025-11-03 09:39:41.526111
328	2	V	2	Regular	150.0	t	\N	2025-11-03 09:39:41.527053	2025-11-03 09:39:41.527053
329	2	V	3	Regular	150.0	t	\N	2025-11-03 09:39:41.527912	2025-11-03 09:39:41.527912
330	2	V	4	Regular	150.0	t	\N	2025-11-03 09:39:41.528805	2025-11-03 09:39:41.528805
331	2	V	5	Regular	150.0	t	\N	2025-11-03 09:39:41.529733	2025-11-03 09:39:41.529733
332	2	V	6	Regular	150.0	t	\N	2025-11-03 09:39:41.530895	2025-11-03 09:39:41.530895
333	2	W	1	Regular	150.0	t	\N	2025-11-03 09:39:41.531802	2025-11-03 09:39:41.531802
334	2	W	2	Regular	150.0	t	\N	2025-11-03 09:39:41.532635	2025-11-03 09:39:41.532635
335	2	W	3	Regular	150.0	t	\N	2025-11-03 09:39:41.533477	2025-11-03 09:39:41.533477
336	2	W	4	Regular	150.0	t	\N	2025-11-03 09:39:41.534322	2025-11-03 09:39:41.534322
337	2	W	5	Regular	150.0	t	\N	2025-11-03 09:39:41.535249	2025-11-03 09:39:41.535249
338	2	W	6	Regular	150.0	t	\N	2025-11-03 09:39:41.536051	2025-11-03 09:39:41.536051
339	2	X	1	Regular	150.0	t	\N	2025-11-03 09:39:41.537051	2025-11-03 09:39:41.537051
340	2	X	2	Regular	150.0	t	\N	2025-11-03 09:39:41.538065	2025-11-03 09:39:41.538065
341	2	X	3	Regular	150.0	t	\N	2025-11-03 09:39:41.540112	2025-11-03 09:39:41.540112
342	2	X	4	Regular	150.0	t	\N	2025-11-03 09:39:41.541099	2025-11-03 09:39:41.541099
343	2	X	5	Regular	150.0	t	\N	2025-11-03 09:39:41.542233	2025-11-03 09:39:41.542233
344	2	X	6	Regular	150.0	t	\N	2025-11-03 09:39:41.54364	2025-11-03 09:39:41.54364
345	2	Y	1	Regular	150.0	t	\N	2025-11-03 09:39:41.544802	2025-11-03 09:39:41.544802
346	2	Y	2	Regular	150.0	t	\N	2025-11-03 09:39:41.545783	2025-11-03 09:39:41.545783
347	2	Y	3	Regular	150.0	t	\N	2025-11-03 09:39:41.546636	2025-11-03 09:39:41.546636
348	2	Y	4	Regular	150.0	t	\N	2025-11-03 09:39:41.547733	2025-11-03 09:39:41.547733
349	2	Y	5	Regular	150.0	t	\N	2025-11-03 09:39:41.548541	2025-11-03 09:39:41.548541
350	2	Y	6	Regular	150.0	f	\N	2025-11-03 09:39:41.549356	2025-11-07 08:30:08.617143
\.


--
-- Data for Name: showtime_seats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.showtime_seats (id, showtime_id, seat_id, available, created_at, updated_at) FROM stdin;
1	1	1	t	2025-11-07 09:14:18.115373	2025-11-07 09:14:18.115373
2	1	2	t	2025-11-07 09:14:18.122177	2025-11-07 09:14:18.122177
3	1	3	t	2025-11-07 09:14:18.130125	2025-11-07 09:14:18.130125
4	1	4	t	2025-11-07 09:14:18.137704	2025-11-07 09:14:18.137704
5	1	5	t	2025-11-07 09:14:18.145613	2025-11-07 09:14:18.145613
6	1	6	t	2025-11-07 09:14:18.153393	2025-11-07 09:14:18.153393
7	1	7	t	2025-11-07 09:14:18.161362	2025-11-07 09:14:18.161362
8	1	8	t	2025-11-07 09:14:18.169572	2025-11-07 09:14:18.169572
10	1	10	t	2025-11-07 09:14:18.183412	2025-11-07 09:14:18.183412
11	1	11	t	2025-11-07 09:14:18.189537	2025-11-07 09:14:18.189537
12	1	12	t	2025-11-07 09:14:18.197215	2025-11-07 09:14:18.197215
13	1	13	t	2025-11-07 09:14:18.205237	2025-11-07 09:14:18.205237
14	1	14	t	2025-11-07 09:14:18.213018	2025-11-07 09:14:18.213018
15	1	15	t	2025-11-07 09:14:18.22111	2025-11-07 09:14:18.22111
16	1	16	t	2025-11-07 09:14:18.22903	2025-11-07 09:14:18.22903
17	1	17	t	2025-11-07 09:14:18.236483	2025-11-07 09:14:18.236483
18	1	18	t	2025-11-07 09:14:18.244245	2025-11-07 09:14:18.244245
19	1	19	t	2025-11-07 09:14:18.252218	2025-11-07 09:14:18.252218
20	1	20	t	2025-11-07 09:14:18.259939	2025-11-07 09:14:18.259939
21	1	21	t	2025-11-07 09:14:18.269114	2025-11-07 09:14:18.269114
22	1	22	t	2025-11-07 09:14:18.275368	2025-11-07 09:14:18.275368
23	1	23	t	2025-11-07 09:14:18.284572	2025-11-07 09:14:18.284572
24	1	24	t	2025-11-07 09:14:18.291459	2025-11-07 09:14:18.291459
25	1	25	t	2025-11-07 09:14:18.299864	2025-11-07 09:14:18.299864
26	1	26	t	2025-11-07 09:14:18.30688	2025-11-07 09:14:18.30688
27	1	27	t	2025-11-07 09:14:18.314699	2025-11-07 09:14:18.314699
28	1	28	t	2025-11-07 09:14:18.322526	2025-11-07 09:14:18.322526
29	1	29	t	2025-11-07 09:14:18.330323	2025-11-07 09:14:18.330323
30	1	30	t	2025-11-07 09:14:18.337462	2025-11-07 09:14:18.337462
31	1	31	t	2025-11-07 09:14:18.344623	2025-11-07 09:14:18.344623
32	1	32	t	2025-11-07 09:14:18.352031	2025-11-07 09:14:18.352031
33	1	33	t	2025-11-07 09:14:18.359602	2025-11-07 09:14:18.359602
34	1	34	t	2025-11-07 09:14:18.368231	2025-11-07 09:14:18.368231
35	1	35	t	2025-11-07 09:14:18.374958	2025-11-07 09:14:18.374958
36	1	36	t	2025-11-07 09:14:18.382723	2025-11-07 09:14:18.382723
37	1	37	t	2025-11-07 09:14:18.38936	2025-11-07 09:14:18.38936
38	1	38	t	2025-11-07 09:14:18.39619	2025-11-07 09:14:18.39619
39	1	39	t	2025-11-07 09:14:18.404152	2025-11-07 09:14:18.404152
40	1	40	t	2025-11-07 09:14:18.410959	2025-11-07 09:14:18.410959
41	1	41	t	2025-11-07 09:14:18.419057	2025-11-07 09:14:18.419057
42	1	42	t	2025-11-07 09:14:18.424648	2025-11-07 09:14:18.424648
43	1	43	t	2025-11-07 09:14:18.43145	2025-11-07 09:14:18.43145
44	1	44	t	2025-11-07 09:14:18.438278	2025-11-07 09:14:18.438278
45	1	45	t	2025-11-07 09:14:18.445939	2025-11-07 09:14:18.445939
46	1	46	t	2025-11-07 09:14:18.452504	2025-11-07 09:14:18.452504
47	1	47	t	2025-11-07 09:14:18.459116	2025-11-07 09:14:18.459116
48	1	48	t	2025-11-07 09:14:18.467206	2025-11-07 09:14:18.467206
49	1	49	t	2025-11-07 09:14:18.473834	2025-11-07 09:14:18.473834
50	1	50	t	2025-11-07 09:14:18.482034	2025-11-07 09:14:18.482034
51	1	51	t	2025-11-07 09:14:18.489349	2025-11-07 09:14:18.489349
52	1	52	t	2025-11-07 09:14:18.495458	2025-11-07 09:14:18.495458
53	1	53	t	2025-11-07 09:14:18.502637	2025-11-07 09:14:18.502637
54	1	54	t	2025-11-07 09:14:18.510028	2025-11-07 09:14:18.510028
55	1	55	t	2025-11-07 09:14:18.517967	2025-11-07 09:14:18.517967
56	1	56	t	2025-11-07 09:14:18.524373	2025-11-07 09:14:18.524373
57	1	57	t	2025-11-07 09:14:18.533384	2025-11-07 09:14:18.533384
58	1	58	t	2025-11-07 09:14:18.540369	2025-11-07 09:14:18.540369
59	1	59	t	2025-11-07 09:14:18.548333	2025-11-07 09:14:18.548333
60	1	60	t	2025-11-07 09:14:18.555651	2025-11-07 09:14:18.555651
61	1	61	t	2025-11-07 09:14:18.564824	2025-11-07 09:14:18.564824
62	1	62	t	2025-11-07 09:14:18.574189	2025-11-07 09:14:18.574189
63	1	63	t	2025-11-07 09:14:18.582183	2025-11-07 09:14:18.582183
64	1	64	t	2025-11-07 09:14:18.593354	2025-11-07 09:14:18.593354
65	1	65	t	2025-11-07 09:14:18.602609	2025-11-07 09:14:18.602609
66	1	66	t	2025-11-07 09:14:18.609281	2025-11-07 09:14:18.609281
67	1	67	t	2025-11-07 09:14:18.617283	2025-11-07 09:14:18.617283
68	1	68	t	2025-11-07 09:14:18.623149	2025-11-07 09:14:18.623149
69	1	69	t	2025-11-07 09:14:18.630028	2025-11-07 09:14:18.630028
70	1	70	t	2025-11-07 09:14:18.63668	2025-11-07 09:14:18.63668
71	1	71	t	2025-11-07 09:14:18.64213	2025-11-07 09:14:18.64213
72	1	72	t	2025-11-07 09:14:18.649847	2025-11-07 09:14:18.649847
73	1	73	t	2025-11-07 09:14:18.654777	2025-11-07 09:14:18.654777
74	1	74	t	2025-11-07 09:14:18.660214	2025-11-07 09:14:18.660214
75	1	75	t	2025-11-07 09:14:18.667625	2025-11-07 09:14:18.667625
76	1	76	t	2025-11-07 09:14:18.67298	2025-11-07 09:14:18.67298
77	1	77	t	2025-11-07 09:14:18.678293	2025-11-07 09:14:18.678293
78	1	78	t	2025-11-07 09:14:18.684565	2025-11-07 09:14:18.684565
79	1	79	t	2025-11-07 09:14:18.689353	2025-11-07 09:14:18.689353
80	1	80	t	2025-11-07 09:14:18.695423	2025-11-07 09:14:18.695423
81	1	81	t	2025-11-07 09:14:18.701947	2025-11-07 09:14:18.701947
82	1	82	t	2025-11-07 09:14:18.707191	2025-11-07 09:14:18.707191
83	1	83	t	2025-11-07 09:14:18.71333	2025-11-07 09:14:18.71333
84	1	84	t	2025-11-07 09:14:18.719312	2025-11-07 09:14:18.719312
85	1	85	t	2025-11-07 09:14:18.726184	2025-11-07 09:14:18.726184
86	1	86	t	2025-11-07 09:14:18.733248	2025-11-07 09:14:18.733248
87	1	87	t	2025-11-07 09:14:18.738967	2025-11-07 09:14:18.738967
88	1	88	t	2025-11-07 09:14:18.743978	2025-11-07 09:14:18.743978
89	1	89	t	2025-11-07 09:14:18.750921	2025-11-07 09:14:18.750921
90	1	90	t	2025-11-07 09:14:18.757849	2025-11-07 09:14:18.757849
91	1	91	t	2025-11-07 09:14:18.766914	2025-11-07 09:14:18.766914
92	1	92	t	2025-11-07 09:14:18.773294	2025-11-07 09:14:18.773294
93	1	93	t	2025-11-07 09:14:18.780357	2025-11-07 09:14:18.780357
94	1	94	t	2025-11-07 09:14:18.785723	2025-11-07 09:14:18.785723
95	1	95	t	2025-11-07 09:14:18.792072	2025-11-07 09:14:18.792072
96	1	96	t	2025-11-07 09:14:18.799205	2025-11-07 09:14:18.799205
97	1	97	t	2025-11-07 09:14:18.805103	2025-11-07 09:14:18.805103
98	1	98	t	2025-11-07 09:14:18.811271	2025-11-07 09:14:18.811271
99	1	99	t	2025-11-07 09:14:18.81731	2025-11-07 09:14:18.81731
100	1	100	t	2025-11-07 09:14:18.821319	2025-11-07 09:14:18.821319
101	1	101	t	2025-11-07 09:14:18.824605	2025-11-07 09:14:18.824605
102	1	102	t	2025-11-07 09:14:18.828964	2025-11-07 09:14:18.828964
103	1	103	t	2025-11-07 09:14:18.832993	2025-11-07 09:14:18.832993
104	1	104	t	2025-11-07 09:14:18.8363	2025-11-07 09:14:18.8363
105	1	105	t	2025-11-07 09:14:18.839912	2025-11-07 09:14:18.839912
106	1	106	t	2025-11-07 09:14:18.843333	2025-11-07 09:14:18.843333
107	1	107	t	2025-11-07 09:14:18.849645	2025-11-07 09:14:18.849645
108	1	108	t	2025-11-07 09:14:18.856469	2025-11-07 09:14:18.856469
109	1	109	t	2025-11-07 09:14:18.863216	2025-11-07 09:14:18.863216
110	1	110	t	2025-11-07 09:14:18.870868	2025-11-07 09:14:18.870868
111	1	111	t	2025-11-07 09:14:18.877179	2025-11-07 09:14:18.877179
112	1	112	t	2025-11-07 09:14:18.885809	2025-11-07 09:14:18.885809
113	1	113	t	2025-11-07 09:14:18.892297	2025-11-07 09:14:18.892297
114	1	114	t	2025-11-07 09:14:18.901021	2025-11-07 09:14:18.901021
115	1	115	t	2025-11-07 09:14:18.908649	2025-11-07 09:14:18.908649
116	1	116	t	2025-11-07 09:14:18.9165	2025-11-07 09:14:18.9165
117	1	117	t	2025-11-07 09:14:18.921342	2025-11-07 09:14:18.921342
118	1	118	t	2025-11-07 09:14:18.926868	2025-11-07 09:14:18.926868
119	1	119	t	2025-11-07 09:14:18.932814	2025-11-07 09:14:18.932814
120	1	120	t	2025-11-07 09:14:18.937399	2025-11-07 09:14:18.937399
121	1	121	t	2025-11-07 09:14:18.942532	2025-11-07 09:14:18.942532
122	1	122	t	2025-11-07 09:14:18.948697	2025-11-07 09:14:18.948697
123	1	123	t	2025-11-07 09:14:18.95335	2025-11-07 09:14:18.95335
124	1	124	t	2025-11-07 09:14:18.958113	2025-11-07 09:14:18.958113
125	1	125	t	2025-11-07 09:14:18.963653	2025-11-07 09:14:18.963653
126	1	126	t	2025-11-07 09:14:18.969952	2025-11-07 09:14:18.969952
127	1	127	t	2025-11-07 09:14:18.975338	2025-11-07 09:14:18.975338
128	1	128	t	2025-11-07 09:14:18.9815	2025-11-07 09:14:18.9815
129	1	129	t	2025-11-07 09:14:18.987825	2025-11-07 09:14:18.987825
130	1	130	t	2025-11-07 09:14:18.994504	2025-11-07 09:14:18.994504
131	1	131	t	2025-11-07 09:14:19.000844	2025-11-07 09:14:19.000844
132	1	132	t	2025-11-07 09:14:19.005578	2025-11-07 09:14:19.005578
133	1	133	t	2025-11-07 09:14:19.012329	2025-11-07 09:14:19.012329
134	1	134	t	2025-11-07 09:14:19.017695	2025-11-07 09:14:19.017695
135	1	135	t	2025-11-07 09:14:19.025481	2025-11-07 09:14:19.025481
136	1	136	t	2025-11-07 09:14:19.033771	2025-11-07 09:14:19.033771
137	1	137	t	2025-11-07 09:14:19.040499	2025-11-07 09:14:19.040499
138	1	138	t	2025-11-07 09:14:19.049973	2025-11-07 09:14:19.049973
139	1	139	t	2025-11-07 09:14:19.057414	2025-11-07 09:14:19.057414
140	1	140	t	2025-11-07 09:14:19.066596	2025-11-07 09:14:19.066596
141	1	141	t	2025-11-07 09:14:19.072955	2025-11-07 09:14:19.072955
142	1	142	t	2025-11-07 09:14:19.080375	2025-11-07 09:14:19.080375
143	1	143	t	2025-11-07 09:14:19.087266	2025-11-07 09:14:19.087266
144	1	144	t	2025-11-07 09:14:19.093281	2025-11-07 09:14:19.093281
145	1	145	t	2025-11-07 09:14:19.099886	2025-11-07 09:14:19.099886
146	1	146	t	2025-11-07 09:14:19.104704	2025-11-07 09:14:19.104704
147	1	147	t	2025-11-07 09:14:19.11009	2025-11-07 09:14:19.11009
148	1	148	t	2025-11-07 09:14:19.116418	2025-11-07 09:14:19.116418
149	1	149	t	2025-11-07 09:14:19.12217	2025-11-07 09:14:19.12217
150	1	150	t	2025-11-07 09:14:19.129036	2025-11-07 09:14:19.129036
151	1	151	t	2025-11-07 09:14:19.135159	2025-11-07 09:14:19.135159
152	1	152	t	2025-11-07 09:14:19.140514	2025-11-07 09:14:19.140514
153	1	153	t	2025-11-07 09:14:19.144825	2025-11-07 09:14:19.144825
154	1	154	t	2025-11-07 09:14:19.150039	2025-11-07 09:14:19.150039
155	1	155	t	2025-11-07 09:14:19.15533	2025-11-07 09:14:19.15533
156	1	156	t	2025-11-07 09:14:19.162836	2025-11-07 09:14:19.162836
157	1	157	t	2025-11-07 09:14:19.169263	2025-11-07 09:14:19.169263
158	1	158	t	2025-11-07 09:14:19.175657	2025-11-07 09:14:19.175657
159	1	159	t	2025-11-07 09:14:19.182107	2025-11-07 09:14:19.182107
160	1	160	t	2025-11-07 09:14:19.188452	2025-11-07 09:14:19.188452
161	1	161	t	2025-11-07 09:14:19.194708	2025-11-07 09:14:19.194708
162	1	162	t	2025-11-07 09:14:19.200234	2025-11-07 09:14:19.200234
163	1	163	t	2025-11-07 09:14:19.206217	2025-11-07 09:14:19.206217
164	1	164	t	2025-11-07 09:14:19.210417	2025-11-07 09:14:19.210417
165	1	165	t	2025-11-07 09:14:19.218485	2025-11-07 09:14:19.218485
166	1	166	t	2025-11-07 09:14:19.225262	2025-11-07 09:14:19.225262
167	1	167	t	2025-11-07 09:14:19.233935	2025-11-07 09:14:19.233935
168	1	168	t	2025-11-07 09:14:19.23988	2025-11-07 09:14:19.23988
169	1	169	t	2025-11-07 09:14:19.245657	2025-11-07 09:14:19.245657
170	1	170	t	2025-11-07 09:14:19.252632	2025-11-07 09:14:19.252632
171	1	171	t	2025-11-07 09:14:19.257988	2025-11-07 09:14:19.257988
172	1	172	t	2025-11-07 09:14:19.264934	2025-11-07 09:14:19.264934
173	1	173	t	2025-11-07 09:14:19.272364	2025-11-07 09:14:19.272364
174	1	174	t	2025-11-07 09:14:19.279163	2025-11-07 09:14:19.279163
175	1	175	t	2025-11-07 09:14:19.285632	2025-11-07 09:14:19.285632
176	1	176	t	2025-11-07 09:14:19.29142	2025-11-07 09:14:19.29142
177	1	177	t	2025-11-07 09:14:19.298583	2025-11-07 09:14:19.298583
178	1	178	t	2025-11-07 09:14:19.306071	2025-11-07 09:14:19.306071
179	1	179	t	2025-11-07 09:14:19.313145	2025-11-07 09:14:19.313145
180	1	180	t	2025-11-07 09:14:19.320622	2025-11-07 09:14:19.320622
181	1	181	t	2025-11-07 09:14:19.325641	2025-11-07 09:14:19.325641
182	1	182	t	2025-11-07 09:14:19.333394	2025-11-07 09:14:19.333394
183	1	183	t	2025-11-07 09:14:19.340125	2025-11-07 09:14:19.340125
184	1	184	t	2025-11-07 09:14:19.348024	2025-11-07 09:14:19.348024
185	1	185	t	2025-11-07 09:14:19.355578	2025-11-07 09:14:19.355578
186	1	186	t	2025-11-07 09:14:19.363124	2025-11-07 09:14:19.363124
187	1	187	t	2025-11-07 09:14:19.370621	2025-11-07 09:14:19.370621
188	1	188	t	2025-11-07 09:14:19.376803	2025-11-07 09:14:19.376803
189	1	189	t	2025-11-07 09:14:19.385168	2025-11-07 09:14:19.385168
190	1	190	t	2025-11-07 09:14:19.392724	2025-11-07 09:14:19.392724
191	1	191	t	2025-11-07 09:14:19.401113	2025-11-07 09:14:19.401113
192	1	192	t	2025-11-07 09:14:19.407978	2025-11-07 09:14:19.407978
193	1	193	t	2025-11-07 09:14:19.4157	2025-11-07 09:14:19.4157
194	1	194	t	2025-11-07 09:14:19.421898	2025-11-07 09:14:19.421898
195	1	195	t	2025-11-07 09:14:19.429104	2025-11-07 09:14:19.429104
196	1	196	t	2025-11-07 09:14:19.436196	2025-11-07 09:14:19.436196
197	1	197	t	2025-11-07 09:14:19.442511	2025-11-07 09:14:19.442511
198	1	198	t	2025-11-07 09:14:19.449967	2025-11-07 09:14:19.449967
199	1	199	t	2025-11-07 09:14:19.456653	2025-11-07 09:14:19.456653
200	1	200	t	2025-11-07 09:14:19.461542	2025-11-07 09:14:19.461542
202	2	202	t	2025-11-07 09:14:19.483727	2025-11-07 09:14:19.483727
203	2	203	t	2025-11-07 09:14:19.492557	2025-11-07 09:14:19.492557
204	2	204	t	2025-11-07 09:14:19.500446	2025-11-07 09:14:19.500446
205	2	205	t	2025-11-07 09:14:19.508354	2025-11-07 09:14:19.508354
206	2	206	t	2025-11-07 09:14:19.517723	2025-11-07 09:14:19.517723
207	2	207	t	2025-11-07 09:14:19.524519	2025-11-07 09:14:19.524519
208	2	208	t	2025-11-07 09:14:19.532976	2025-11-07 09:14:19.532976
209	2	209	t	2025-11-07 09:14:19.5376	2025-11-07 09:14:19.5376
210	2	210	t	2025-11-07 09:14:19.542409	2025-11-07 09:14:19.542409
211	2	211	t	2025-11-07 09:14:19.54947	2025-11-07 09:14:19.54947
212	2	212	t	2025-11-07 09:14:19.556794	2025-11-07 09:14:19.556794
213	2	213	t	2025-11-07 09:14:19.564871	2025-11-07 09:14:19.564871
214	2	214	t	2025-11-07 09:14:19.57241	2025-11-07 09:14:19.57241
215	2	215	t	2025-11-07 09:14:19.579425	2025-11-07 09:14:19.579425
216	2	216	t	2025-11-07 09:14:19.588013	2025-11-07 09:14:19.588013
217	2	217	t	2025-11-07 09:14:19.596119	2025-11-07 09:14:19.596119
218	2	218	t	2025-11-07 09:14:19.602676	2025-11-07 09:14:19.602676
219	2	219	t	2025-11-07 09:14:19.610162	2025-11-07 09:14:19.610162
220	2	220	t	2025-11-07 09:14:19.617923	2025-11-07 09:14:19.617923
221	2	221	t	2025-11-07 09:14:19.624848	2025-11-07 09:14:19.624848
222	2	222	t	2025-11-07 09:14:19.632742	2025-11-07 09:14:19.632742
223	2	223	t	2025-11-07 09:14:19.637315	2025-11-07 09:14:19.637315
224	2	224	t	2025-11-07 09:14:19.641434	2025-11-07 09:14:19.641434
225	2	225	t	2025-11-07 09:14:19.649092	2025-11-07 09:14:19.649092
226	2	226	t	2025-11-07 09:14:19.65568	2025-11-07 09:14:19.65568
227	2	227	t	2025-11-07 09:14:19.663389	2025-11-07 09:14:19.663389
228	2	228	t	2025-11-07 09:14:19.670287	2025-11-07 09:14:19.670287
229	2	229	t	2025-11-07 09:14:19.676867	2025-11-07 09:14:19.676867
230	2	230	t	2025-11-07 09:14:19.685372	2025-11-07 09:14:19.685372
231	2	231	t	2025-11-07 09:14:19.69183	2025-11-07 09:14:19.69183
232	2	232	t	2025-11-07 09:14:19.699036	2025-11-07 09:14:19.699036
233	2	233	t	2025-11-07 09:14:19.70385	2025-11-07 09:14:19.70385
234	2	234	t	2025-11-07 09:14:19.708559	2025-11-07 09:14:19.708559
235	2	235	t	2025-11-07 09:14:19.715538	2025-11-07 09:14:19.715538
236	2	236	t	2025-11-07 09:14:19.720685	2025-11-07 09:14:19.720685
238	2	238	t	2025-11-07 09:14:19.732467	2025-11-07 09:14:19.732467
239	2	239	t	2025-11-07 09:14:19.737253	2025-11-07 09:14:19.737253
240	2	240	t	2025-11-07 09:14:19.744039	2025-11-07 09:14:19.744039
241	2	241	t	2025-11-07 09:14:19.751775	2025-11-07 09:14:19.751775
242	2	242	t	2025-11-07 09:14:19.758234	2025-11-07 09:14:19.758234
243	2	243	t	2025-11-07 09:14:19.76661	2025-11-07 09:14:19.76661
244	2	244	t	2025-11-07 09:14:19.773731	2025-11-07 09:14:19.773731
245	2	245	t	2025-11-07 09:14:19.780881	2025-11-07 09:14:19.780881
246	2	246	t	2025-11-07 09:14:19.788391	2025-11-07 09:14:19.788391
247	2	247	t	2025-11-07 09:14:19.795195	2025-11-07 09:14:19.795195
248	2	248	t	2025-11-07 09:14:19.802522	2025-11-07 09:14:19.802522
249	2	249	t	2025-11-07 09:14:19.808871	2025-11-07 09:14:19.808871
250	2	250	t	2025-11-07 09:14:19.815781	2025-11-07 09:14:19.815781
251	2	251	t	2025-11-07 09:14:19.822313	2025-11-07 09:14:19.822313
252	2	252	t	2025-11-07 09:14:19.828929	2025-11-07 09:14:19.828929
253	2	253	t	2025-11-07 09:14:19.834923	2025-11-07 09:14:19.834923
254	2	254	t	2025-11-07 09:14:19.84153	2025-11-07 09:14:19.84153
255	2	255	t	2025-11-07 09:14:19.848153	2025-11-07 09:14:19.848153
256	2	256	t	2025-11-07 09:14:19.852794	2025-11-07 09:14:19.852794
257	2	257	t	2025-11-07 09:14:19.856808	2025-11-07 09:14:19.856808
258	2	258	t	2025-11-07 09:14:19.86217	2025-11-07 09:14:19.86217
259	2	259	t	2025-11-07 09:14:19.867754	2025-11-07 09:14:19.867754
260	2	260	t	2025-11-07 09:14:19.872487	2025-11-07 09:14:19.872487
261	2	261	t	2025-11-07 09:14:19.875596	2025-11-07 09:14:19.875596
262	2	262	t	2025-11-07 09:14:19.882117	2025-11-07 09:14:19.882117
263	2	263	t	2025-11-07 09:14:19.888152	2025-11-07 09:14:19.888152
264	2	264	t	2025-11-07 09:14:19.892559	2025-11-07 09:14:19.892559
265	2	265	t	2025-11-07 09:14:19.89653	2025-11-07 09:14:19.89653
266	2	266	t	2025-11-07 09:14:19.900888	2025-11-07 09:14:19.900888
267	2	267	t	2025-11-07 09:14:19.905102	2025-11-07 09:14:19.905102
268	2	268	t	2025-11-07 09:14:19.911901	2025-11-07 09:14:19.911901
269	2	269	t	2025-11-07 09:14:19.919325	2025-11-07 09:14:19.919325
270	2	270	t	2025-11-07 09:14:19.925163	2025-11-07 09:14:19.925163
271	2	271	t	2025-11-07 09:14:19.937413	2025-11-07 09:14:19.937413
272	2	272	t	2025-11-07 09:14:19.947972	2025-11-07 09:14:19.947972
273	2	273	t	2025-11-07 09:14:19.955999	2025-11-07 09:14:19.955999
274	2	274	t	2025-11-07 09:14:19.965535	2025-11-07 09:14:19.965535
275	2	275	t	2025-11-07 09:14:19.973437	2025-11-07 09:14:19.973437
276	2	276	t	2025-11-07 09:14:19.983487	2025-11-07 09:14:19.983487
277	2	277	t	2025-11-07 09:14:19.9908	2025-11-07 09:14:19.9908
278	2	278	t	2025-11-07 09:14:20.000052	2025-11-07 09:14:20.000052
279	2	279	t	2025-11-07 09:14:20.007692	2025-11-07 09:14:20.007692
280	2	280	t	2025-11-07 09:14:20.016408	2025-11-07 09:14:20.016408
281	2	281	t	2025-11-07 09:14:20.024561	2025-11-07 09:14:20.024561
282	2	282	t	2025-11-07 09:14:20.033353	2025-11-07 09:14:20.033353
283	2	283	t	2025-11-07 09:14:20.041782	2025-11-07 09:14:20.041782
284	2	284	t	2025-11-07 09:14:20.050826	2025-11-07 09:14:20.050826
285	2	285	t	2025-11-07 09:14:20.059319	2025-11-07 09:14:20.059319
286	2	286	t	2025-11-07 09:14:20.068052	2025-11-07 09:14:20.068052
287	2	287	t	2025-11-07 09:14:20.074951	2025-11-07 09:14:20.074951
288	2	288	t	2025-11-07 09:14:20.083772	2025-11-07 09:14:20.083772
289	2	289	t	2025-11-07 09:14:20.089992	2025-11-07 09:14:20.089992
290	2	290	t	2025-11-07 09:14:20.096679	2025-11-07 09:14:20.096679
291	2	291	t	2025-11-07 09:14:20.103092	2025-11-07 09:14:20.103092
292	2	292	t	2025-11-07 09:14:20.110698	2025-11-07 09:14:20.110698
293	2	293	t	2025-11-07 09:14:20.119592	2025-11-07 09:14:20.119592
294	2	294	t	2025-11-07 09:14:20.126509	2025-11-07 09:14:20.126509
295	2	295	t	2025-11-07 09:14:20.134878	2025-11-07 09:14:20.134878
296	2	296	t	2025-11-07 09:14:20.143075	2025-11-07 09:14:20.143075
297	2	297	t	2025-11-07 09:14:20.152402	2025-11-07 09:14:20.152402
298	2	298	t	2025-11-07 09:14:20.160182	2025-11-07 09:14:20.160182
299	2	299	t	2025-11-07 09:14:20.168542	2025-11-07 09:14:20.168542
300	2	300	t	2025-11-07 09:14:20.177302	2025-11-07 09:14:20.177302
301	2	301	t	2025-11-07 09:14:20.184825	2025-11-07 09:14:20.184825
302	2	302	t	2025-11-07 09:14:20.190391	2025-11-07 09:14:20.190391
303	2	303	t	2025-11-07 09:14:20.19402	2025-11-07 09:14:20.19402
304	2	304	t	2025-11-07 09:14:20.201276	2025-11-07 09:14:20.201276
305	2	305	t	2025-11-07 09:14:20.208599	2025-11-07 09:14:20.208599
306	2	306	t	2025-11-07 09:14:20.216856	2025-11-07 09:14:20.216856
307	2	307	t	2025-11-07 09:14:20.224216	2025-11-07 09:14:20.224216
308	2	308	t	2025-11-07 09:14:20.233552	2025-11-07 09:14:20.233552
309	2	309	t	2025-11-07 09:14:20.240597	2025-11-07 09:14:20.240597
310	2	310	t	2025-11-07 09:14:20.247301	2025-11-07 09:14:20.247301
311	2	311	t	2025-11-07 09:14:20.253762	2025-11-07 09:14:20.253762
312	2	312	t	2025-11-07 09:14:20.258574	2025-11-07 09:14:20.258574
313	2	313	t	2025-11-07 09:14:20.266636	2025-11-07 09:14:20.266636
314	2	314	t	2025-11-07 09:14:20.275089	2025-11-07 09:14:20.275089
315	2	315	t	2025-11-07 09:14:20.283962	2025-11-07 09:14:20.283962
316	2	316	t	2025-11-07 09:14:20.291801	2025-11-07 09:14:20.291801
317	2	317	t	2025-11-07 09:14:20.300865	2025-11-07 09:14:20.300865
318	2	318	t	2025-11-07 09:14:20.308465	2025-11-07 09:14:20.308465
319	2	319	t	2025-11-07 09:14:20.316478	2025-11-07 09:14:20.316478
320	2	320	t	2025-11-07 09:14:20.32245	2025-11-07 09:14:20.32245
321	2	321	t	2025-11-07 09:14:20.327078	2025-11-07 09:14:20.327078
322	2	322	t	2025-11-07 09:14:20.333434	2025-11-07 09:14:20.333434
323	2	323	t	2025-11-07 09:14:20.340491	2025-11-07 09:14:20.340491
324	2	324	t	2025-11-07 09:14:20.34678	2025-11-07 09:14:20.34678
325	2	325	t	2025-11-07 09:14:20.352457	2025-11-07 09:14:20.352457
326	2	326	t	2025-11-07 09:14:20.357875	2025-11-07 09:14:20.357875
327	2	327	t	2025-11-07 09:14:20.364447	2025-11-07 09:14:20.364447
328	2	328	t	2025-11-07 09:14:20.370292	2025-11-07 09:14:20.370292
329	2	329	t	2025-11-07 09:14:20.375989	2025-11-07 09:14:20.375989
330	2	330	t	2025-11-07 09:14:20.382709	2025-11-07 09:14:20.382709
331	2	331	t	2025-11-07 09:14:20.388872	2025-11-07 09:14:20.388872
332	2	332	t	2025-11-07 09:14:20.394236	2025-11-07 09:14:20.394236
333	2	333	t	2025-11-07 09:14:20.400468	2025-11-07 09:14:20.400468
334	2	334	t	2025-11-07 09:14:20.405816	2025-11-07 09:14:20.405816
335	2	335	t	2025-11-07 09:14:20.410939	2025-11-07 09:14:20.410939
336	2	336	t	2025-11-07 09:14:20.417572	2025-11-07 09:14:20.417572
337	2	337	t	2025-11-07 09:14:20.422097	2025-11-07 09:14:20.422097
338	2	338	t	2025-11-07 09:14:20.427765	2025-11-07 09:14:20.427765
339	2	339	t	2025-11-07 09:14:20.434457	2025-11-07 09:14:20.434457
340	2	340	t	2025-11-07 09:14:20.440232	2025-11-07 09:14:20.440232
341	2	341	t	2025-11-07 09:14:20.447354	2025-11-07 09:14:20.447354
342	2	342	t	2025-11-07 09:14:20.453676	2025-11-07 09:14:20.453676
343	2	343	t	2025-11-07 09:14:20.459592	2025-11-07 09:14:20.459592
344	2	344	t	2025-11-07 09:14:20.466357	2025-11-07 09:14:20.466357
345	2	345	t	2025-11-07 09:14:20.473804	2025-11-07 09:14:20.473804
346	2	346	t	2025-11-07 09:14:20.479711	2025-11-07 09:14:20.479711
347	2	347	t	2025-11-07 09:14:20.486107	2025-11-07 09:14:20.486107
348	2	348	t	2025-11-07 09:14:20.492672	2025-11-07 09:14:20.492672
349	2	349	t	2025-11-07 09:14:20.498646	2025-11-07 09:14:20.498646
350	2	350	t	2025-11-07 09:14:20.504628	2025-11-07 09:14:20.504628
352	3	202	t	2025-11-07 09:14:20.523605	2025-11-07 09:14:20.523605
353	3	203	t	2025-11-07 09:14:20.528583	2025-11-07 09:14:20.528583
354	3	204	t	2025-11-07 09:14:20.534189	2025-11-07 09:14:20.534189
355	3	205	t	2025-11-07 09:14:20.539597	2025-11-07 09:14:20.539597
356	3	206	t	2025-11-07 09:14:20.545204	2025-11-07 09:14:20.545204
357	3	207	t	2025-11-07 09:14:20.551561	2025-11-07 09:14:20.551561
358	3	208	t	2025-11-07 09:14:20.55929	2025-11-07 09:14:20.55929
359	3	209	t	2025-11-07 09:14:20.566646	2025-11-07 09:14:20.566646
360	3	210	t	2025-11-07 09:14:20.573447	2025-11-07 09:14:20.573447
361	3	211	t	2025-11-07 09:14:20.578934	2025-11-07 09:14:20.578934
362	3	212	t	2025-11-07 09:14:20.584568	2025-11-07 09:14:20.584568
363	3	213	t	2025-11-07 09:14:20.58942	2025-11-07 09:14:20.58942
364	3	214	t	2025-11-07 09:14:20.596481	2025-11-07 09:14:20.596481
365	3	215	t	2025-11-07 09:14:20.603517	2025-11-07 09:14:20.603517
366	3	216	t	2025-11-07 09:14:20.608342	2025-11-07 09:14:20.608342
367	3	217	t	2025-11-07 09:14:20.613917	2025-11-07 09:14:20.613917
368	3	218	t	2025-11-07 09:14:20.619864	2025-11-07 09:14:20.619864
369	3	219	t	2025-11-07 09:14:20.625281	2025-11-07 09:14:20.625281
370	3	220	t	2025-11-07 09:14:20.633452	2025-11-07 09:14:20.633452
371	3	221	t	2025-11-07 09:14:20.640208	2025-11-07 09:14:20.640208
372	3	222	t	2025-11-07 09:14:20.647597	2025-11-07 09:14:20.647597
373	3	223	t	2025-11-07 09:14:20.653225	2025-11-07 09:14:20.653225
374	3	224	t	2025-11-07 09:14:20.658626	2025-11-07 09:14:20.658626
375	3	225	t	2025-11-07 09:14:20.664819	2025-11-07 09:14:20.664819
376	3	226	t	2025-11-07 09:14:20.671506	2025-11-07 09:14:20.671506
377	3	227	t	2025-11-07 09:14:20.677806	2025-11-07 09:14:20.677806
378	3	228	t	2025-11-07 09:14:20.684492	2025-11-07 09:14:20.684492
379	3	229	t	2025-11-07 09:14:20.690512	2025-11-07 09:14:20.690512
380	3	230	t	2025-11-07 09:14:20.69718	2025-11-07 09:14:20.69718
381	3	231	t	2025-11-07 09:14:20.703074	2025-11-07 09:14:20.703074
382	3	232	t	2025-11-07 09:14:20.708974	2025-11-07 09:14:20.708974
383	3	233	t	2025-11-07 09:14:20.715491	2025-11-07 09:14:20.715491
384	3	234	t	2025-11-07 09:14:20.720877	2025-11-07 09:14:20.720877
385	3	235	t	2025-11-07 09:14:20.725954	2025-11-07 09:14:20.725954
386	3	236	t	2025-11-07 09:14:20.732556	2025-11-07 09:14:20.732556
387	3	237	t	2025-11-07 09:14:20.736727	2025-11-07 09:14:20.736727
388	3	238	t	2025-11-07 09:14:20.741056	2025-11-07 09:14:20.741056
389	3	239	t	2025-11-07 09:14:20.747797	2025-11-07 09:14:20.747797
390	3	240	t	2025-11-07 09:14:20.75425	2025-11-07 09:14:20.75425
391	3	241	t	2025-11-07 09:14:20.760578	2025-11-07 09:14:20.760578
392	3	242	t	2025-11-07 09:14:20.768213	2025-11-07 09:14:20.768213
393	3	243	t	2025-11-07 09:14:20.774778	2025-11-07 09:14:20.774778
394	3	244	t	2025-11-07 09:14:20.781308	2025-11-07 09:14:20.781308
395	3	245	t	2025-11-07 09:14:20.788789	2025-11-07 09:14:20.788789
396	3	246	t	2025-11-07 09:14:20.795132	2025-11-07 09:14:20.795132
397	3	247	t	2025-11-07 09:14:20.802188	2025-11-07 09:14:20.802188
398	3	248	t	2025-11-07 09:14:20.807175	2025-11-07 09:14:20.807175
399	3	249	t	2025-11-07 09:14:20.813653	2025-11-07 09:14:20.813653
400	3	250	t	2025-11-07 09:14:20.819492	2025-11-07 09:14:20.819492
401	3	251	t	2025-11-07 09:14:20.824637	2025-11-07 09:14:20.824637
402	3	252	t	2025-11-07 09:14:20.831177	2025-11-07 09:14:20.831177
403	3	253	t	2025-11-07 09:14:20.837417	2025-11-07 09:14:20.837417
404	3	254	t	2025-11-07 09:14:20.842324	2025-11-07 09:14:20.842324
405	3	255	t	2025-11-07 09:14:20.848143	2025-11-07 09:14:20.848143
406	3	256	t	2025-11-07 09:14:20.854179	2025-11-07 09:14:20.854179
407	3	257	t	2025-11-07 09:14:20.860088	2025-11-07 09:14:20.860088
408	3	258	t	2025-11-07 09:14:20.866814	2025-11-07 09:14:20.866814
409	3	259	t	2025-11-07 09:14:20.87331	2025-11-07 09:14:20.87331
410	3	260	t	2025-11-07 09:14:20.880279	2025-11-07 09:14:20.880279
411	3	261	t	2025-11-07 09:14:20.885047	2025-11-07 09:14:20.885047
412	3	262	t	2025-11-07 09:14:20.88962	2025-11-07 09:14:20.88962
413	3	263	t	2025-11-07 09:14:20.8968	2025-11-07 09:14:20.8968
414	3	264	t	2025-11-07 09:14:20.903139	2025-11-07 09:14:20.903139
415	3	265	t	2025-11-07 09:14:20.908494	2025-11-07 09:14:20.908494
416	3	266	t	2025-11-07 09:14:20.912756	2025-11-07 09:14:20.912756
417	3	267	t	2025-11-07 09:14:20.917999	2025-11-07 09:14:20.917999
418	3	268	t	2025-11-07 09:14:20.922571	2025-11-07 09:14:20.922571
419	3	269	t	2025-11-07 09:14:20.929383	2025-11-07 09:14:20.929383
420	3	270	t	2025-11-07 09:14:20.934993	2025-11-07 09:14:20.934993
421	3	271	t	2025-11-07 09:14:20.940139	2025-11-07 09:14:20.940139
422	3	272	t	2025-11-07 09:14:20.948022	2025-11-07 09:14:20.948022
423	3	273	t	2025-11-07 09:14:20.955273	2025-11-07 09:14:20.955273
424	3	274	t	2025-11-07 09:14:20.961581	2025-11-07 09:14:20.961581
425	3	275	t	2025-11-07 09:14:20.969109	2025-11-07 09:14:20.969109
426	3	276	t	2025-11-07 09:14:20.974329	2025-11-07 09:14:20.974329
427	3	277	t	2025-11-07 09:14:20.979926	2025-11-07 09:14:20.979926
428	3	278	t	2025-11-07 09:14:20.986395	2025-11-07 09:14:20.986395
429	3	279	t	2025-11-07 09:14:20.991802	2025-11-07 09:14:20.991802
430	3	280	t	2025-11-07 09:14:20.999584	2025-11-07 09:14:20.999584
431	3	281	t	2025-11-07 09:14:21.005044	2025-11-07 09:14:21.005044
432	3	282	t	2025-11-07 09:14:21.01063	2025-11-07 09:14:21.01063
433	3	283	t	2025-11-07 09:14:21.016539	2025-11-07 09:14:21.016539
434	3	284	t	2025-11-07 09:14:21.021863	2025-11-07 09:14:21.021863
435	3	285	t	2025-11-07 09:14:21.028556	2025-11-07 09:14:21.028556
436	3	286	t	2025-11-07 09:14:21.034557	2025-11-07 09:14:21.034557
437	3	287	t	2025-11-07 09:14:21.040375	2025-11-07 09:14:21.040375
438	3	288	t	2025-11-07 09:14:21.04692	2025-11-07 09:14:21.04692
439	3	289	t	2025-11-07 09:14:21.053845	2025-11-07 09:14:21.053845
440	3	290	t	2025-11-07 09:14:21.059869	2025-11-07 09:14:21.059869
441	3	291	t	2025-11-07 09:14:21.066195	2025-11-07 09:14:21.066195
442	3	292	t	2025-11-07 09:14:21.072056	2025-11-07 09:14:21.072056
443	3	293	t	2025-11-07 09:14:21.078532	2025-11-07 09:14:21.078532
444	3	294	t	2025-11-07 09:14:21.085836	2025-11-07 09:14:21.085836
445	3	295	t	2025-11-07 09:14:21.092346	2025-11-07 09:14:21.092346
446	3	296	t	2025-11-07 09:14:21.099648	2025-11-07 09:14:21.099648
447	3	297	t	2025-11-07 09:14:21.105587	2025-11-07 09:14:21.105587
448	3	298	t	2025-11-07 09:14:21.111833	2025-11-07 09:14:21.111833
449	3	299	t	2025-11-07 09:14:21.118963	2025-11-07 09:14:21.118963
450	3	300	t	2025-11-07 09:14:21.125045	2025-11-07 09:14:21.125045
451	3	301	t	2025-11-07 09:14:21.13072	2025-11-07 09:14:21.13072
452	3	302	t	2025-11-07 09:14:21.135016	2025-11-07 09:14:21.135016
453	3	303	t	2025-11-07 09:14:21.139839	2025-11-07 09:14:21.139839
454	3	304	t	2025-11-07 09:14:21.145007	2025-11-07 09:14:21.145007
455	3	305	t	2025-11-07 09:14:21.149111	2025-11-07 09:14:21.149111
456	3	306	t	2025-11-07 09:14:21.154328	2025-11-07 09:14:21.154328
457	3	307	t	2025-11-07 09:14:21.158988	2025-11-07 09:14:21.158988
458	3	308	t	2025-11-07 09:14:21.166307	2025-11-07 09:14:21.166307
459	3	309	t	2025-11-07 09:14:21.172199	2025-11-07 09:14:21.172199
460	3	310	t	2025-11-07 09:14:21.180312	2025-11-07 09:14:21.180312
461	3	311	t	2025-11-07 09:14:21.188418	2025-11-07 09:14:21.188418
462	3	312	t	2025-11-07 09:14:21.194969	2025-11-07 09:14:21.194969
463	3	313	t	2025-11-07 09:14:21.200437	2025-11-07 09:14:21.200437
464	3	314	t	2025-11-07 09:14:21.206828	2025-11-07 09:14:21.206828
465	3	315	t	2025-11-07 09:14:21.215373	2025-11-07 09:14:21.215373
466	3	316	t	2025-11-07 09:14:21.22163	2025-11-07 09:14:21.22163
467	3	317	t	2025-11-07 09:14:21.227429	2025-11-07 09:14:21.227429
468	3	318	t	2025-11-07 09:14:21.233653	2025-11-07 09:14:21.233653
469	3	319	t	2025-11-07 09:14:21.238467	2025-11-07 09:14:21.238467
470	3	320	t	2025-11-07 09:14:21.243769	2025-11-07 09:14:21.243769
471	3	321	t	2025-11-07 09:14:21.249986	2025-11-07 09:14:21.249986
472	3	322	t	2025-11-07 09:14:21.255354	2025-11-07 09:14:21.255354
473	3	323	t	2025-11-07 09:14:21.260092	2025-11-07 09:14:21.260092
474	3	324	t	2025-11-07 09:14:21.266672	2025-11-07 09:14:21.266672
475	3	325	t	2025-11-07 09:14:21.271003	2025-11-07 09:14:21.271003
476	3	326	t	2025-11-07 09:14:21.275863	2025-11-07 09:14:21.275863
477	3	327	t	2025-11-07 09:14:21.281646	2025-11-07 09:14:21.281646
478	3	328	t	2025-11-07 09:14:21.286451	2025-11-07 09:14:21.286451
479	3	329	t	2025-11-07 09:14:21.291192	2025-11-07 09:14:21.291192
480	3	330	t	2025-11-07 09:14:21.296882	2025-11-07 09:14:21.296882
481	3	331	t	2025-11-07 09:14:21.301778	2025-11-07 09:14:21.301778
482	3	332	t	2025-11-07 09:14:21.30608	2025-11-07 09:14:21.30608
483	3	333	t	2025-11-07 09:14:21.313722	2025-11-07 09:14:21.313722
484	3	334	t	2025-11-07 09:14:21.319176	2025-11-07 09:14:21.319176
485	3	335	t	2025-11-07 09:14:21.324985	2025-11-07 09:14:21.324985
486	3	336	t	2025-11-07 09:14:21.330808	2025-11-07 09:14:21.330808
487	3	337	t	2025-11-07 09:14:21.338198	2025-11-07 09:14:21.338198
488	3	338	t	2025-11-07 09:14:21.345103	2025-11-07 09:14:21.345103
489	3	339	t	2025-11-07 09:14:21.353042	2025-11-07 09:14:21.353042
490	3	340	t	2025-11-07 09:14:21.358844	2025-11-07 09:14:21.358844
491	3	341	t	2025-11-07 09:14:21.367396	2025-11-07 09:14:21.367396
492	3	342	t	2025-11-07 09:14:21.374454	2025-11-07 09:14:21.374454
493	3	343	t	2025-11-07 09:14:21.383148	2025-11-07 09:14:21.383148
494	3	344	t	2025-11-07 09:14:21.388325	2025-11-07 09:14:21.388325
495	3	345	t	2025-11-07 09:14:21.394713	2025-11-07 09:14:21.394713
496	3	346	t	2025-11-07 09:14:21.401099	2025-11-07 09:14:21.401099
497	3	347	t	2025-11-07 09:14:21.406107	2025-11-07 09:14:21.406107
498	3	348	t	2025-11-07 09:14:21.410581	2025-11-07 09:14:21.410581
499	3	349	t	2025-11-07 09:14:21.415576	2025-11-07 09:14:21.415576
500	3	350	t	2025-11-07 09:14:21.419584	2025-11-07 09:14:21.419584
237	2	237	f	2025-11-07 09:14:19.725208	2025-11-07 09:14:19.725208
201	2	201	f	2025-11-07 09:14:19.476098	2025-11-07 09:14:19.476098
351	3	201	f	2025-11-07 09:14:20.518436	2025-11-07 09:14:20.518436
9	1	9	t	2025-11-07 09:14:18.176636	2025-11-07 09:14:18.176636
\.


--
-- Data for Name: showtimes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.showtimes (id, movie_id, screen_id, start_time, end_time, language, available_seats, deleted_at, created_at, updated_at) FROM stdin;
1	1	1	2025-11-11 10:00:00	2025-11-11 13:00:00	English	200	\N	2025-11-03 09:39:41.562329	2025-11-07 06:37:56.757368
2	2	2	2025-11-11 14:00:00	2025-11-11 17:00:00	English	150	\N	2025-11-03 09:39:41.56605	2025-11-07 06:38:09.816042
3	2	2	2025-11-11 05:50:00	2025-11-11 08:10:00	Hindi	150	\N	2025-11-07 06:46:56.78652	2025-11-07 06:46:56.78652
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, name, created_at, updated_at) FROM stdin;
1	Action	2025-11-03 09:39:41.095684	2025-11-03 09:39:41.095684
2	Adventure	2025-11-03 09:39:41.100232	2025-11-03 09:39:41.100232
3	Comedy	2025-11-03 09:39:41.108137	2025-11-03 09:39:41.108137
4	Drama	2025-11-03 09:39:41.112543	2025-11-03 09:39:41.112543
5	Horror	2025-11-03 09:39:41.118145	2025-11-03 09:39:41.118145
6	Sci-Fi	2025-11-03 09:39:41.121984	2025-11-03 09:39:41.121984
7	Romance	2025-11-03 09:39:41.12635	2025-11-03 09:39:41.12635
8	Thriller	2025-11-03 09:39:41.132806	2025-11-03 09:39:41.132806
9	Animation	2025-11-03 09:39:41.137107	2025-11-03 09:39:41.137107
10	Fantasy	2025-11-03 09:39:41.141284	2025-11-03 09:39:41.141284
\.


--
-- Data for Name: theatres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.theatres (id, name, address, city, state, country, rating, deleted_at, created_at, updated_at) FROM stdin;
1	PVR Cinemas	123 Main St	Mumbai	MH	India	4.5	\N	2025-11-03 09:39:41.080384	2025-11-03 09:39:41.080384
2	INOX	456 Park Lane	Delhi	DL	India	4.2	\N	2025-11-03 09:39:41.086864	2025-11-03 09:39:41.086864
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password_digest, is_admin, created_at, updated_at, phone) FROM stdin;
1	Admin	admin@gmail.com	$2a$12$4ZYMV2bQ/c5E8yRO7B9eQuYKPOOueUtXgbQhgVhsB1xo4/egPnFUm	t	2025-11-03 09:39:40.855596	2025-11-03 09:39:40.855596	9876543210
2	User	user@gmail.com	$2a$12$E6NFWWlbIF.BjEi2aG9POuDPx2ceWKFlJL54w10Ti959XPD8FGzXy	f	2025-11-03 09:39:41.066996	2025-11-03 09:39:41.066996	1234567890
4	Test	test@gmail.com	$2a$12$4TUgUwZ6BRmGT7qfUCUhfOkAFE1dO8cIWdCDNhW.uPSCuvcHfV6mq	f	2025-11-06 11:12:29.508999	2025-11-06 11:12:29.508999	9876543210
5	Rohan	Rohan@gmail.com	$2a$12$pNLtl3oZLzFqo5UFNy0XIOQ84TvsNlp0ZHjy4iXfK3K/a2j9NTrnS	f	2025-11-06 12:10:27.098838	2025-11-06 12:10:27.098838	1234569870
6	Jhon	jhon@gmail.com	$2a$12$9UADGMUYa7B0pgOVQ4BUeOZpsL7p6OT888HT94au5HoyjfGgE7bJO	f	2025-11-06 12:24:35.182577	2025-11-06 12:24:35.182577	123456789876543456
7	mike	mike@gmail.com	$2a$12$XVEEomefh/TBMwRyZtAtBeTwFrgZjdduyj65cNW7f..2I6UPK745.	f	2025-11-06 12:46:02.92889	2025-11-06 12:46:02.92889	9876543217
8	Aman	aman@gmail.com	$2a$12$ZUSzFhR4tcNh8dXjovfUoe3.4l0x9go.dVfQuuHiILMuQYInrImM6	f	2025-11-07 04:16:17.896354	2025-11-07 04:16:17.896354	9876543218
3	user1	user1@gmail.com	$2a$12$6uqVd5cgjn/LcOM9FUhArugODGkBePxPsE4VsHtqHOENpltCBwu02	f	2025-11-06 10:18:24.152226	2025-11-07 06:24:15.693547	9876543210
11	Raj	raj@gmail.com	$2a$12$oCtqV/QX/3JhRgnMMGN3R.IkWuacWonv3/np5PCaTwvrZUPZD8hJC	f	2025-11-07 12:29:15.251061	2025-11-07 12:29:15.251061	9876543456
12	Raju	raju@gmail.com	$2a$12$uQsYfbPGjiQGaE6LD.tizumIBbCdaKUwCNM.Xhn9B6OSe7lm/lgn2	f	2025-11-07 16:28:22.376522	2025-11-07 16:28:22.376522	8765434567
13	t1t	t1t@gmail.com	$2a$12$3ibiuPfkjS0/XXMosP6Yoefg1jxOJF/7a664gBmdN4yQLfxo9pE9C	f	2025-11-07 16:30:24.656262	2025-11-07 16:30:24.656262	9876543345
\.


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_id_seq', 1, false);


--
-- Name: movie_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_tags_id_seq', 13, true);


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_id_seq', 8, true);


--
-- Name: reservations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservations_id_seq', 26, true);


--
-- Name: screens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.screens_id_seq', 2, true);


--
-- Name: seats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seats_id_seq', 350, true);


--
-- Name: showtime_seats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.showtime_seats_id_seq', 500, true);


--
-- Name: showtimes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.showtimes_id_seq', 3, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 10, true);


--
-- Name: theatres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.theatres_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 13, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: movie_tags movie_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_tags
    ADD CONSTRAINT movie_tags_pkey PRIMARY KEY (id);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: screens screens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screens
    ADD CONSTRAINT screens_pkey PRIMARY KEY (id);


--
-- Name: seats seats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (id);


--
-- Name: showtime_seats showtime_seats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtime_seats
    ADD CONSTRAINT showtime_seats_pkey PRIMARY KEY (id);


--
-- Name: showtimes showtimes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtimes
    ADD CONSTRAINT showtimes_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: theatres theatres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.theatres
    ADD CONSTRAINT theatres_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_bookings_on_showtime_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_bookings_on_showtime_id ON public.bookings USING btree (showtime_id);


--
-- Name: index_bookings_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_bookings_on_user_id ON public.bookings USING btree (user_id);


--
-- Name: index_movie_tags_on_movie_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_movie_tags_on_movie_id ON public.movie_tags USING btree (movie_id);


--
-- Name: index_movie_tags_on_movie_id_and_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_movie_tags_on_movie_id_and_tag_id ON public.movie_tags USING btree (movie_id, tag_id);


--
-- Name: index_movie_tags_on_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_movie_tags_on_tag_id ON public.movie_tags USING btree (tag_id);


--
-- Name: index_movies_on_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_movies_on_deleted_at ON public.movies USING btree (deleted_at);


--
-- Name: index_movies_tags_on_movie_id_and_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_movies_tags_on_movie_id_and_tag_id ON public.movies_tags USING btree (movie_id, tag_id);


--
-- Name: index_movies_tags_on_tag_id_and_movie_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_movies_tags_on_tag_id_and_movie_id ON public.movies_tags USING btree (tag_id, movie_id);


--
-- Name: index_reservations_on_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reservations_on_deleted_at ON public.reservations USING btree (deleted_at);


--
-- Name: index_reservations_on_showtime_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reservations_on_showtime_id ON public.reservations USING btree (showtime_id);


--
-- Name: index_reservations_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reservations_on_user_id ON public.reservations USING btree (user_id);


--
-- Name: index_reservations_seats_on_reservation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reservations_seats_on_reservation_id ON public.reservations_seats USING btree (reservation_id);


--
-- Name: index_reservations_seats_on_reservation_id_and_seat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_reservations_seats_on_reservation_id_and_seat_id ON public.reservations_seats USING btree (reservation_id, seat_id);


--
-- Name: index_reservations_seats_on_seat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reservations_seats_on_seat_id ON public.reservations_seats USING btree (seat_id);


--
-- Name: index_screens_on_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_screens_on_deleted_at ON public.screens USING btree (deleted_at);


--
-- Name: index_screens_on_theatre_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_screens_on_theatre_id ON public.screens USING btree (theatre_id);


--
-- Name: index_seats_on_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_seats_on_deleted_at ON public.seats USING btree (deleted_at);


--
-- Name: index_seats_on_screen_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_seats_on_screen_id ON public.seats USING btree (screen_id);


--
-- Name: index_showtime_seats_on_seat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_showtime_seats_on_seat_id ON public.showtime_seats USING btree (seat_id);


--
-- Name: index_showtime_seats_on_showtime_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_showtime_seats_on_showtime_id ON public.showtime_seats USING btree (showtime_id);


--
-- Name: index_showtime_seats_on_showtime_id_and_seat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_showtime_seats_on_showtime_id_and_seat_id ON public.showtime_seats USING btree (showtime_id, seat_id);


--
-- Name: index_showtimes_on_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_showtimes_on_deleted_at ON public.showtimes USING btree (deleted_at);


--
-- Name: index_showtimes_on_movie_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_showtimes_on_movie_id ON public.showtimes USING btree (movie_id);


--
-- Name: index_showtimes_on_screen_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_showtimes_on_screen_id ON public.showtimes USING btree (screen_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_theatres_on_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_theatres_on_deleted_at ON public.theatres USING btree (deleted_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: seats fk_rails_199a07ec24; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT fk_rails_199a07ec24 FOREIGN KEY (screen_id) REFERENCES public.screens(id);


--
-- Name: reservations_seats fk_rails_1bade5ccc8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations_seats
    ADD CONSTRAINT fk_rails_1bade5ccc8 FOREIGN KEY (seat_id) REFERENCES public.seats(id);


--
-- Name: movie_tags fk_rails_2d5165d4b5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_tags
    ADD CONSTRAINT fk_rails_2d5165d4b5 FOREIGN KEY (movie_id) REFERENCES public.movies(id);


--
-- Name: bookings fk_rails_36eb2c69ce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_36eb2c69ce FOREIGN KEY (showtime_id) REFERENCES public.showtimes(id);


--
-- Name: showtimes fk_rails_3fc119ff04; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtimes
    ADD CONSTRAINT fk_rails_3fc119ff04 FOREIGN KEY (movie_id) REFERENCES public.movies(id);


--
-- Name: reservations fk_rails_48a92fce51; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT fk_rails_48a92fce51 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: movie_tags fk_rails_4d61dcda77; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_tags
    ADD CONSTRAINT fk_rails_4d61dcda77 FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: screens fk_rails_794b75290c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screens
    ADD CONSTRAINT fk_rails_794b75290c FOREIGN KEY (theatre_id) REFERENCES public.theatres(id);


--
-- Name: reservations_seats fk_rails_7db86feca8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations_seats
    ADD CONSTRAINT fk_rails_7db86feca8 FOREIGN KEY (reservation_id) REFERENCES public.reservations(id);


--
-- Name: reservations fk_rails_92ee00a428; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT fk_rails_92ee00a428 FOREIGN KEY (showtime_id) REFERENCES public.showtimes(id);


--
-- Name: showtime_seats fk_rails_b4c0541183; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtime_seats
    ADD CONSTRAINT fk_rails_b4c0541183 FOREIGN KEY (seat_id) REFERENCES public.seats(id);


--
-- Name: showtimes fk_rails_bcc36c3c51; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtimes
    ADD CONSTRAINT fk_rails_bcc36c3c51 FOREIGN KEY (screen_id) REFERENCES public.screens(id);


--
-- Name: showtime_seats fk_rails_d52edac476; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.showtime_seats
    ADD CONSTRAINT fk_rails_d52edac476 FOREIGN KEY (showtime_id) REFERENCES public.showtimes(id);


--
-- Name: bookings fk_rails_ef0571f117; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_ef0571f117 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict s1PCbtD08n6lfdLsaFEPdu1aurfZ5GEkdzUctnjGqQoz6e7pkjpcYsKAmGNzTo7

