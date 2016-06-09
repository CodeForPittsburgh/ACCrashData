create extension postgis;
select AddGeometryColumn('accrashdata', 'geom', 4326, 'point', 2);
update accrashdata set geom = ST_SetSRID(ST_POINT(dec_long, dec_lat), 4326);
create index accrashdata_geom_idx on accrashdata using gist (geom);
