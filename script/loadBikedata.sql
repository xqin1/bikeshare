--create table
drop table if exists xiaoming.bikeshare2012 CASCADE;
create table xiaoming.bikeshare2012
(
	duration character varying(100),
	seconds integer,
	startdate timestamp,
	startstation character varying(100),
	startterminal character varying(100),
	enddate timestamp,
	endstation character varying(100),
	endterminal character varying(100),
	bikeid character varying(100),
	usertype character varying(20)
	
);
ALTER TABLE xiaoming.bikeshare2012 OWNER TO postgres;
drop table if exists xiaoming.bikeshare2012_1 CASCADE;
create table xiaoming.bikeshare2012_1
(
	duration character varying(100),
	seconds integer,
	startdate timestamp,
	startstation character varying(100),
	startterminal character varying(100),
	enddate timestamp,
	endstation character varying(100),
	endterminal character varying(100),
	bikeid character varying(100),
	usertype character varying(20)
	
);
ALTER TABLE xiaoming.bikeshare2012_1 OWNER TO postgres;

copy xiaoming.bikeshare2012_1 from '/Users/qinxiaoming/Documents/gisdata/bikeshare/2012-1st-quarter.csv' using delimiters ',' CSV HEADER;
insert into xiaoming.bikeshare2012 select duration,seconds,startdate,startstation,startterminal,enddate,endstation,endterminal,bikeid,usertype from xiaoming.bikeshare2012_1;
drop table if exists xiaoming.bikeshare2012_1 CASCADE;

drop table if exists xiaoming.bikeshare2012_2 CASCADE;
create table xiaoming.bikeshare2012_2
(
	duration character varying(100),
	seconds integer,
	startdate timestamp,
	startstation character varying(100),
	startterminal character varying(100),
	enddate timestamp,
	endstation character varying(100),
	endterminal character varying(100),
	bikeid character varying(100),
	usertype character varying(20)
	
);
ALTER TABLE xiaoming.bikeshare2012_2 OWNER TO postgres;

copy xiaoming.bikeshare2012_2 from '/Users/qinxiaoming/Documents/gisdata/bikeshare/2012-2nd-quarter.csv' using delimiters ',' CSV HEADER;
insert into xiaoming.bikeshare2012 select duration,seconds,startdate,startstation,startterminal,enddate,endstation,endterminal,bikeid,usertype from xiaoming.bikeshare2012_2;
drop table if exists xiaoming.bikeshare2012_2 CASCADE;

--no seconds column for 3rd and 4th quarter
drop table if exists xiaoming.bikeshare2012_3 CASCADE;
create table xiaoming.bikeshare2012_3
(
	duration character varying(100),
	--seconds integer,
	startdate timestamp,
	startstation character varying(100),
	startterminal character varying(100),
	enddate timestamp,
	endstation character varying(100),
	endterminal character varying(100),
	bikeid character varying(100),
	usertype character varying(20)
	
);
ALTER TABLE xiaoming.bikeshare2012_3 OWNER TO postgres;

copy xiaoming.bikeshare2012_3 from '/Users/qinxiaoming/Documents/gisdata/bikeshare/2012-3rd-quarter.csv' using delimiters ',' CSV HEADER;
insert into xiaoming.bikeshare2012 select duration,0,startdate,startstation,startterminal,enddate,endstation,endterminal,bikeid,usertype from xiaoming.bikeshare2012_3;
drop table if exists xiaoming.bikeshare2012_3 CASCADE;

drop table if exists xiaoming.bikeshare2012_4 CASCADE;
create table xiaoming.bikeshare2012_4
(
	duration character varying(100),
	--seconds integer,
	startdate timestamp,
	startstation character varying(100),
	startterminal character varying(100),
	enddate timestamp,
	endstation character varying(100),
	endterminal character varying(100),
	bikeid character varying(100),
	usertype character varying(20)
	
);
ALTER TABLE xiaoming.bikeshare2012_4 OWNER TO postgres;

copy xiaoming.bikeshare2012_4 from '/Users/qinxiaoming/Documents/gisdata/bikeshare/2012-4th-quarter.csv' using delimiters ',' CSV HEADER;
insert into xiaoming.bikeshare2012 select duration,0,startdate,startstation,startterminal,enddate,endstation,endterminal,bikeid,usertype from xiaoming.bikeshare2012_4;
drop table if exists xiaoming.bikeshare2012_4 CASCADE;

--manipulage the table
--create new column to store whole hour
update xiaoming.bikeshare2012 set startdatehour = date_trunc('hour', startdate), enddatehour=date_trunc('hour',enddate)

--get count for every terminal
create table xiaoming.start_terminal_count as 
select startterminal, count(startterminal)
from xiaoming.bikeshare2012
group by startterminal

create table xiaoming.end_terminal_count as 
select endterminal, count(endterminal)
from xiaoming.bikeshare2012
group by endterminal

create table xiaoming.terminal_count as 
select a.startterminal,a.count as checkout, b.count as checkin, (a.count+b.count) as total
from xiaoming.start_terminal_count a, xiaoming.end_terminal_count b
where a.startterminal = b.endterminal
order by total

--create hourly checkin/checkout count by station
create table xiaoming.startCountByHour as 
select date_part('hour',startdatehour) as hour, startterminal, count(startterminal) as startcount
from xiaoming.bikeshare2012
--where startterminal='31000'
group by startterminal, date_part('hour',startdatehour)
order by date_part('hour',startdatehour)

create table xiaoming.endCountByHour as 
select date_part('hour',enddatehour) as hour, endterminal, count(endterminal) as endcount
from xiaoming.bikeshare2012
--where endterminal='31000'
group by endterminal, date_part('hour',enddatehour)
order by date_part('hour',enddatehour)

create table xiaoming.hourly_count_by_terminal as 
select a.startterminal, a.hour,a.startcount, b.endcount
from xiaoming.startCountByHour a, xiaoming.endCountByHour b
where a.startterminal=b.endterminal and a.hour = b.hour
