-- Table: public.month_of_year

-- DROP TABLE public.month_of_year;

CREATE TABLE public.month_of_year
(
  id integer NOT NULL,
  name character varying(9),
  CONSTRAINT month_of_yearid PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.month_of_year
  OWNER TO postgres;
