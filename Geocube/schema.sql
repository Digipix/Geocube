
-- Scheme for Geocube

create table config (
    id integer primary key,
    key text,
    value text
);
create index config_idx_key on config(key);
insert into config(key, value) values("version", "1");

create table filters (
    id integer primary key,
    key text,
    value text
);
create index filters_idx_key on filters(key);

create table groups (
    id integer primary key,
    usergroup integer,
    name text
);
create index groups_idx_id on groups(id);
insert into groups(name, usergroup) values("All Waypoints", 0);
insert into groups(name, usergroup) values("All Waypoints - Found", 0);
insert into groups(name, usergroup) values("All Waypoints - Attended", 0);
insert into groups(name, usergroup) values("All Waypoints - Not Found", 0);
insert into groups(name, usergroup) values("All Waypoints - Manually entered", 0);
insert into groups(name, usergroup) values("Last Import", 0);
insert into groups(name, usergroup) values("Last Import - New", 0);
insert into groups(name, usergroup) values("GCA - NSW", 1);
insert into groups(name, usergroup) values("GC - ACT", 1);
insert into groups(name, usergroup) values("Waymarking - Caringbah", 1);
insert into groups(name, usergroup) values("IOS Sim - FreeWay", 1);

create table group2waypoints (
    id integer primary key,
    waypoint_id integer,		-- points to waypoints(id)
    group_id integer			-- points to groups(id)
);
create index group2waypoints_idx_group_id on group2waypoints(group_id);
create index group2waypoints_idx_waypoint_id on group2waypoints(waypoint_id);

create table waypoints (
    id integer primary key,
    lat text,
    lon text,
    lat_int integer,			-- lat times 1000 000 for now
    lon_int integer,			-- lon times 1000 000 for now
    name text,
    description text,
    date_placed string,
    date_placed_epoch integer,
    url text,
    urlname text,
    symbol_id integer,			-- pointer to symbols(id)
    type_id integer,			-- pointer to types(id)
    groundspeak_id integer,		-- pointer to groundspeak(id)

    log_status integer			-- 0 not logged, 1 DNF, 2 found
);
create index waypoint_idx_name on waypoints(name);
create index waypoint_idx_id on waypoints(id);

create table groundspeak (
    id integer primary key,
    waypoint_id integer,		-- pointer to waypoints(id)
    archived bool,
    available bool,
    country_id integer,			-- pointer to countries(id)
    state_id integer,			-- pointer to states(id)
    rating_difficulty float,
    rating_terrain float,
    favourites integer,
    long_desc_html bool,
    long_desc text,
    short_desc_html bool,
    short_desc text,
    hint text,
    container_id integer,		-- pointer to containers(id)
    placed_by text,
    owner_id integer			-- pointer to names(id)
);

create table names (
    id integer primary key,
    name text,
    code text
);
create index names_idx_id on names(id);
create index names_idx_name on names(name);

create table countries (
    id integer primary key,
    name text,
    code text
);
create index countries_idx_id on countries(id);
create index countries_idx_name on countries(name);
insert into countries(code, name) values("AD", "Andorra");
insert into countries(code, name) values("AE", "United Arab Emirates");
insert into countries(code, name) values("AF", "Afghanistan");
insert into countries(code, name) values("AG", "Antigua & Barbuda");
insert into countries(code, name) values("AI", "Anguilla");
insert into countries(code, name) values("AL", "Albania");
insert into countries(code, name) values("AM", "Armenia");
insert into countries(code, name) values("AO", "Angola");
insert into countries(code, name) values("AQ", "Antarctica");
insert into countries(code, name) values("AR", "Argentina");
insert into countries(code, name) values("AS", "Samoa (American)");
insert into countries(code, name) values("AT", "Austria");
insert into countries(code, name) values("AU", "Australia");
insert into countries(code, name) values("AW", "Aruba");
insert into countries(code, name) values("AX", "Aaland Islands");
insert into countries(code, name) values("AZ", "Azerbaijan");
insert into countries(code, name) values("BA", "Bosnia & Herzegovina");
insert into countries(code, name) values("BB", "Barbados");
insert into countries(code, name) values("BD", "Bangladesh");
insert into countries(code, name) values("BE", "Belgium");
insert into countries(code, name) values("BF", "Burkina Faso");
insert into countries(code, name) values("BG", "Bulgaria");
insert into countries(code, name) values("BH", "Bahrain");
insert into countries(code, name) values("BI", "Burundi");
insert into countries(code, name) values("BJ", "Benin");
insert into countries(code, name) values("BL", "St Barthelemy");
insert into countries(code, name) values("BM", "Bermuda");
insert into countries(code, name) values("BN", "Brunei");
insert into countries(code, name) values("BO", "Bolivia");
insert into countries(code, name) values("BQ", "Caribbean Netherlands");
insert into countries(code, name) values("BR", "Brazil");
insert into countries(code, name) values("BS", "Bahamas");
insert into countries(code, name) values("BT", "Bhutan");
insert into countries(code, name) values("BV", "Bouvet Island");
insert into countries(code, name) values("BW", "Botswana");
insert into countries(code, name) values("BY", "Belarus");
insert into countries(code, name) values("BZ", "Belize");
insert into countries(code, name) values("CA", "Canada");
insert into countries(code, name) values("CC", "Cocos (Keeling) Islands");
insert into countries(code, name) values("CD", "Congo (Dem. Rep.)");
insert into countries(code, name) values("CF", "Central African Rep.");
insert into countries(code, name) values("CG", "Congo (Rep.)");
insert into countries(code, name) values("CH", "Switzerland");
insert into countries(code, name) values("CI", "Cote d'Ivoire");
insert into countries(code, name) values("CK", "Cook Islands");
insert into countries(code, name) values("CL", "Chile");
insert into countries(code, name) values("CM", "Cameroon");
insert into countries(code, name) values("CN", "China");
insert into countries(code, name) values("CO", "Colombia");
insert into countries(code, name) values("CR", "Costa Rica");
insert into countries(code, name) values("CU", "Cuba");
insert into countries(code, name) values("CV", "Cape Verde");
insert into countries(code, name) values("CW", "Curacao");
insert into countries(code, name) values("CX", "Christmas Island");
insert into countries(code, name) values("CY", "Cyprus");
insert into countries(code, name) values("CZ", "Czech Republic");
insert into countries(code, name) values("DE", "Germany");
insert into countries(code, name) values("DJ", "Djibouti");
insert into countries(code, name) values("DK", "Denmark");
insert into countries(code, name) values("DM", "Dominica");
insert into countries(code, name) values("DO", "Dominican Republic");
insert into countries(code, name) values("DZ", "Algeria");
insert into countries(code, name) values("EC", "Ecuador");
insert into countries(code, name) values("EE", "Estonia");
insert into countries(code, name) values("EG", "Egypt");
insert into countries(code, name) values("EH", "Western Sahara");
insert into countries(code, name) values("ER", "Eritrea");
insert into countries(code, name) values("ES", "Spain");
insert into countries(code, name) values("ET", "Ethiopia");
insert into countries(code, name) values("FI", "Finland");
insert into countries(code, name) values("FJ", "Fiji");
insert into countries(code, name) values("FK", "Falkland Islands");
insert into countries(code, name) values("FM", "Micronesia");
insert into countries(code, name) values("FO", "Faroe Islands");
insert into countries(code, name) values("FR", "France");
insert into countries(code, name) values("GA", "Gabon");
insert into countries(code, name) values("GB", "Britain (UK)");
insert into countries(code, name) values("GD", "Grenada");
insert into countries(code, name) values("GE", "Georgia");
insert into countries(code, name) values("GF", "French Guiana");
insert into countries(code, name) values("GG", "Guernsey");
insert into countries(code, name) values("GH", "Ghana");
insert into countries(code, name) values("GI", "Gibraltar");
insert into countries(code, name) values("GL", "Greenland");
insert into countries(code, name) values("GM", "Gambia");
insert into countries(code, name) values("GN", "Guinea");
insert into countries(code, name) values("GP", "Guadeloupe");
insert into countries(code, name) values("GQ", "Equatorial Guinea");
insert into countries(code, name) values("GR", "Greece");
insert into countries(code, name) values("GS", "South Georgia & the South Sandwich Islands");
insert into countries(code, name) values("GT", "Guatemala");
insert into countries(code, name) values("GU", "Guam");
insert into countries(code, name) values("GW", "Guinea-Bissau");
insert into countries(code, name) values("GY", "Guyana");
insert into countries(code, name) values("HK", "Hong Kong");
insert into countries(code, name) values("HM", "Heard Island & McDonald Islands");
insert into countries(code, name) values("HN", "Honduras");
insert into countries(code, name) values("HR", "Croatia");
insert into countries(code, name) values("HT", "Haiti");
insert into countries(code, name) values("HU", "Hungary");
insert into countries(code, name) values("ID", "Indonesia");
insert into countries(code, name) values("IE", "Ireland");
insert into countries(code, name) values("IL", "Israel");
insert into countries(code, name) values("IM", "Isle of Man");
insert into countries(code, name) values("IN", "India");
insert into countries(code, name) values("IO", "British Indian Ocean Territory");
insert into countries(code, name) values("IQ", "Iraq");
insert into countries(code, name) values("IR", "Iran");
insert into countries(code, name) values("IS", "Iceland");
insert into countries(code, name) values("IT", "Italy");
insert into countries(code, name) values("JE", "Jersey");
insert into countries(code, name) values("JM", "Jamaica");
insert into countries(code, name) values("JO", "Jordan");
insert into countries(code, name) values("JP", "Japan");
insert into countries(code, name) values("KE", "Kenya");
insert into countries(code, name) values("KG", "Kyrgyzstan");
insert into countries(code, name) values("KH", "Cambodia");
insert into countries(code, name) values("KI", "Kiribati");
insert into countries(code, name) values("KM", "Comoros");
insert into countries(code, name) values("KN", "St Kitts & Nevis");
insert into countries(code, name) values("KP", "Korea (North)");
insert into countries(code, name) values("KR", "Korea (South)");
insert into countries(code, name) values("KW", "Kuwait");
insert into countries(code, name) values("KY", "Cayman Islands");
insert into countries(code, name) values("KZ", "Kazakhstan");
insert into countries(code, name) values("LA", "Laos");
insert into countries(code, name) values("LB", "Lebanon");
insert into countries(code, name) values("LC", "St Lucia");
insert into countries(code, name) values("LI", "Liechtenstein");
insert into countries(code, name) values("LK", "Sri Lanka");
insert into countries(code, name) values("LR", "Liberia");
insert into countries(code, name) values("LS", "Lesotho");
insert into countries(code, name) values("LT", "Lithuania");
insert into countries(code, name) values("LU", "Luxembourg");
insert into countries(code, name) values("LV", "Latvia");
insert into countries(code, name) values("LY", "Libya");
insert into countries(code, name) values("MA", "Morocco");
insert into countries(code, name) values("MC", "Monaco");
insert into countries(code, name) values("MD", "Moldova");
insert into countries(code, name) values("ME", "Montenegro");
insert into countries(code, name) values("MF", "St Martin (French part)");
insert into countries(code, name) values("MG", "Madagascar");
insert into countries(code, name) values("MH", "Marshall Islands");
insert into countries(code, name) values("MK", "Macedonia");
insert into countries(code, name) values("ML", "Mali");
insert into countries(code, name) values("MM", "Myanmar (Burma)");
insert into countries(code, name) values("MN", "Mongolia");
insert into countries(code, name) values("MO", "Macau");
insert into countries(code, name) values("MP", "Northern Mariana Islands");
insert into countries(code, name) values("MQ", "Martinique");
insert into countries(code, name) values("MR", "Mauritania");
insert into countries(code, name) values("MS", "Montserrat");
insert into countries(code, name) values("MT", "Malta");
insert into countries(code, name) values("MU", "Mauritius");
insert into countries(code, name) values("MV", "Maldives");
insert into countries(code, name) values("MW", "Malawi");
insert into countries(code, name) values("MX", "Mexico");
insert into countries(code, name) values("MY", "Malaysia");
insert into countries(code, name) values("MZ", "Mozambique");
insert into countries(code, name) values("NA", "Namibia");
insert into countries(code, name) values("NC", "New Caledonia");
insert into countries(code, name) values("NE", "Niger");
insert into countries(code, name) values("NF", "Norfolk Island");
insert into countries(code, name) values("NG", "Nigeria");
insert into countries(code, name) values("NI", "Nicaragua");
insert into countries(code, name) values("NL", "Netherlands");
insert into countries(code, name) values("NO", "Norway");
insert into countries(code, name) values("NP", "Nepal");
insert into countries(code, name) values("NR", "Nauru");
insert into countries(code, name) values("NU", "Niue");
insert into countries(code, name) values("NZ", "New Zealand");
insert into countries(code, name) values("OM", "Oman");
insert into countries(code, name) values("PA", "Panama");
insert into countries(code, name) values("PE", "Peru");
insert into countries(code, name) values("PF", "French Polynesia");
insert into countries(code, name) values("PG", "Papua New Guinea");
insert into countries(code, name) values("PH", "Philippines");
insert into countries(code, name) values("PK", "Pakistan");
insert into countries(code, name) values("PL", "Poland");
insert into countries(code, name) values("PM", "St Pierre & Miquelon");
insert into countries(code, name) values("PN", "Pitcairn");
insert into countries(code, name) values("PR", "Puerto Rico");
insert into countries(code, name) values("PS", "Palestine");
insert into countries(code, name) values("PT", "Portugal");
insert into countries(code, name) values("PW", "Palau");
insert into countries(code, name) values("PY", "Paraguay");
insert into countries(code, name) values("QA", "Qatar");
insert into countries(code, name) values("RE", "Reunion");
insert into countries(code, name) values("RO", "Romania");
insert into countries(code, name) values("RS", "Serbia");
insert into countries(code, name) values("RU", "Russia");
insert into countries(code, name) values("RW", "Rwanda");
insert into countries(code, name) values("SA", "Saudi Arabia");
insert into countries(code, name) values("SB", "Solomon Islands");
insert into countries(code, name) values("SC", "Seychelles");
insert into countries(code, name) values("SD", "Sudan");
insert into countries(code, name) values("SE", "Sweden");
insert into countries(code, name) values("SG", "Singapore");
insert into countries(code, name) values("SH", "St Helena");
insert into countries(code, name) values("SI", "Slovenia");
insert into countries(code, name) values("SJ", "Svalbard & Jan Mayen");
insert into countries(code, name) values("SK", "Slovakia");
insert into countries(code, name) values("SL", "Sierra Leone");
insert into countries(code, name) values("SM", "San Marino");
insert into countries(code, name) values("SN", "Senegal");
insert into countries(code, name) values("SO", "Somalia");
insert into countries(code, name) values("SR", "Suriname");
insert into countries(code, name) values("SS", "South Sudan");
insert into countries(code, name) values("ST", "Sao Tome & Principe");
insert into countries(code, name) values("SV", "El Salvador");
insert into countries(code, name) values("SX", "St Maarten (Dutch part)");
insert into countries(code, name) values("SY", "Syria");
insert into countries(code, name) values("SZ", "Swaziland");
insert into countries(code, name) values("TC", "Turks & Caicos Is");
insert into countries(code, name) values("TD", "Chad");
insert into countries(code, name) values("TF", "French Southern & Antarctic Lands");
insert into countries(code, name) values("TG", "Togo");
insert into countries(code, name) values("TH", "Thailand");
insert into countries(code, name) values("TJ", "Tajikistan");
insert into countries(code, name) values("TK", "Tokelau");
insert into countries(code, name) values("TL", "East Timor");
insert into countries(code, name) values("TM", "Turkmenistan");
insert into countries(code, name) values("TN", "Tunisia");
insert into countries(code, name) values("TO", "Tonga");
insert into countries(code, name) values("TR", "Turkey");
insert into countries(code, name) values("TT", "Trinidad & Tobago");
insert into countries(code, name) values("TV", "Tuvalu");
insert into countries(code, name) values("TW", "Taiwan");
insert into countries(code, name) values("TZ", "Tanzania");
insert into countries(code, name) values("UA", "Ukraine");
insert into countries(code, name) values("UG", "Uganda");
insert into countries(code, name) values("UM", "US minor outlying islands");
insert into countries(code, name) values("US", "United States");
insert into countries(code, name) values("UY", "Uruguay");
insert into countries(code, name) values("UZ", "Uzbekistan");
insert into countries(code, name) values("VA", "Vatican City");
insert into countries(code, name) values("VC", "St Vincent");
insert into countries(code, name) values("VE", "Venezuela");
insert into countries(code, name) values("VG", "Virgin Islands (UK)");
insert into countries(code, name) values("VI", "Virgin Islands (US)");
insert into countries(code, name) values("VN", "Vietnam");
insert into countries(code, name) values("VU", "Vanuatu");
insert into countries(code, name) values("WF", "Wallis & Futuna");
insert into countries(code, name) values("WS", "Samoa (western)");
insert into countries(code, name) values("YE", "Yemen");
insert into countries(code, name) values("YT", "Mayotte");
insert into countries(code, name) values("ZA", "South Africa");
insert into countries(code, name) values("ZM", "Zambia");
insert into countries(code, name) values("ZW", "Zimbabwe");

create table states (
    id integer primary key,
    name text,
    code text
);
create index states_idx_id on states(id);
create index states_idx_name on states(name);
insert into states(code, name) values("NSW", "New South Wales");
insert into states(code, name) values("ACT", "Australian Capital Territory");
insert into states(code, name) values("VIC", "Victoria");
insert into states(code, name) values("QLD", "Queensland");
insert into states(code, name) values("TAS", "Tasmania");
insert into states(code, name) values("NT",  "Northern Territory");
insert into states(code, name) values("WA",  "Western Australia");
insert into states(code, name) values("SA",  "South Australia");
insert into states(code, name) values("AL", "Alabama");
insert into states(code, name) values("AK", "Alaska");
insert into states(code, name) values("AZ", "Arizona");
insert into states(code, name) values("AR", "Arkansas");
insert into states(code, name) values("CA", "California");
insert into states(code, name) values("CO", "Colorado");
insert into states(code, name) values("CT", "Connecticut");
insert into states(code, name) values("DE", "Delaware");
insert into states(code, name) values("DC", "District of Columbia");
insert into states(code, name) values("FL", "Florida");
insert into states(code, name) values("GA", "Georgia");
insert into states(code, name) values("HI", "Hawaii");
insert into states(code, name) values("ID", "Idaho");
insert into states(code, name) values("IL", "Illinois");
insert into states(code, name) values("IN", "Indiana");
insert into states(code, name) values("IA", "Iowa");
insert into states(code, name) values("KS", "Kansas");
insert into states(code, name) values("KY", "Kentucky");
insert into states(code, name) values("LA", "Louisiana");
insert into states(code, name) values("ME", "Maine");
insert into states(code, name) values("MT", "Montana");
insert into states(code, name) values("NE", "Nebraska");
insert into states(code, name) values("NV", "Nevada");
insert into states(code, name) values("NH", "New Hampshire");
insert into states(code, name) values("NJ", "New Jersey");
insert into states(code, name) values("NM", "NewMexico");
insert into states(code, name) values("NY", "New York");
insert into states(code, name) values("NC", "North Carolina");
insert into states(code, name) values("ND", "North Dakota");
insert into states(code, name) values("OH", "Ohio");
insert into states(code, name) values("OK", "Oklahoma");
insert into states(code, name) values("OR", "Oregon");
insert into states(code, name) values("MD", "Maryland");
insert into states(code, name) values("MA", "Massachusetts");
insert into states(code, name) values("MI", "Michigan");
insert into states(code, name) values("MN", "Minnesota");
insert into states(code, name) values("MS", "Mississippi");
insert into states(code, name) values("MO", "Missouri");
insert into states(code, name) values("PA", "Pennsylvania");
insert into states(code, name) values("RI", "Rhode Island");
insert into states(code, name) values("SC", "South Carolina");
insert into states(code, name) values("SD", "South Dakota");
insert into states(code, name) values("TN", "Tennessee");
insert into states(code, name) values("TX", "Texas");
insert into states(code, name) values("UT", "Utah");
insert into states(code, name) values("VT", "Vermont");
insert into states(code, name) values("VA", "Virginia");
insert into states(code, name) values("WA", "Washington");
insert into states(code, name) values("WV", "West Virginia");
insert into states(code, name) values("WI", "Wisconsin");
insert into states(code, name) values("WY", "Wyoming");

create table symbols (
    id integer primary key,
    symbol text
);
create index symbols_idx_id on symbols(id);
create index symbols_idx_symbol on symbols(symbol);
insert into symbols(symbol) values("Final Location");
insert into symbols(symbol) values("Geocache Found");
insert into symbols(symbol) values("Geocache");
insert into symbols(symbol) values("Parking Area");
insert into symbols(symbol) values("Physical Stage");
insert into symbols(symbol) values("Reference Point");
insert into symbols(symbol) values("Trailhead");
insert into symbols(symbol) values("Virtual Stage");
insert into symbols(symbol) values("Waymark");
insert into symbols(symbol) values("Waymark Found");

create table types (
    id integer primary key,
    type text,
    icon integer,
    pin integer
);
create index types_idx_id on types(id);
insert into types(type, icon, pin) values("Geocache|Benchmark", 100, 601);
insert into types(type, icon, pin) values("Geocache|CITO", 101, 608);
insert into types(type, icon, pin) values("Geocache|Earthcache", 102, 606);
insert into types(type, icon, pin) values("Geocache|Event Cache", 103, 608);
insert into types(type, icon, pin) values("Geocache|Giga", 104, 608);
insert into types(type, icon, pin) values("Geocache|GroundspeakHQ", 105, 600);
insert into types(type, icon, pin) values("Geocache|Letterbox Hybrid", 106, 601);
insert into types(type, icon, pin) values("Geocache|Maze", 107, 604);
insert into types(type, icon, pin) values("Geocache|Mega", 108, 608);
insert into types(type, icon, pin) values("Geocache|Multi-cache", 109, 607);
insert into types(type, icon, pin) values("Geocache|Mystery", 110, 604);
insert into types(type, icon, pin) values("Geocache|Other", 111, 601);
insert into types(type, icon, pin) values("Geocache|Traditional Cache", 112, 602);
insert into types(type, icon, pin) values("Geocache|Unknown Cache", 113, 604);
insert into types(type, icon, pin) values("Geocache|Virtual Cache", 114, 606);
insert into types(type, icon, pin) values("Geocache|Waymark", 115, 601);
insert into types(type, icon, pin) values("Geocache|Webcam Cache", 116, 606);
insert into types(type, icon, pin) values("Geocache|Wherigo Cache", 117, 603);

insert into types(type, icon, pin) values("Waypoint|Final Location", 200, 600);
insert into types(type, icon, pin) values("Waypoint|Flag", 201, 600);
insert into types(type, icon, pin) values("Waypoint|Multi Stage", 202, 600);
insert into types(type, icon, pin) values("Waypoint|Parking Area", 203, 600);
insert into types(type, icon, pin) values("Waypoint|Physical Stage", 204, 600);
insert into types(type, icon, pin) values("Waypoint|Reference Stage", 205, 600);
insert into types(type, icon, pin) values("Waypoint|Trailhead", 206, 600);
insert into types(type, icon, pin) values("Waypoint|Virtual Stage", 207, 600);

insert into types(type, icon, pin) values("*", 208, 600);

create table log_types (
    id integer primary key,
    logtype text,
    icon integer
);
insert into log_types(logtype, icon) values("Didn't find it", 400);
insert into log_types(logtype, icon) values("Enable Listing", 401);
insert into log_types(logtype, icon) values("Found it", 402);
insert into log_types(logtype, icon) values("Needs Archived", 403);
insert into log_types(logtype, icon) values("Needs Maintenance", 404);
insert into log_types(logtype, icon) values("Owner Maintenance", 405);
insert into log_types(logtype, icon) values("Post Reviewer Note", 406);
insert into log_types(logtype, icon) values("Publish Listing", 407);
insert into log_types(logtype, icon) values("Retract Listing", 408);
insert into log_types(logtype, icon) values("Temporarily Disable Listing", 409);
insert into log_types(logtype, icon) values("Unarchive", 410);
insert into log_types(logtype, icon) values("Update Coordinates", 411);
insert into log_types(logtype, icon) values("Webcam Photo Taken", 412);
insert into log_types(logtype, icon) values("Write note", 413);
insert into log_types(logtype, icon) values("Attended", 414);
insert into log_types(logtype, icon) values("Will Attend", 415);
insert into log_types(logtype, icon) values("Unknown", 416);

create table logs (
    id integer primary key,
    gc_id integer,
    waypoint_id integer,		-- points to waypoints(id)
    log_type_id integer,		-- points to log_types(id)
    datetime text,
    datetime_epoch integer,
    logger_id integer,			-- points to names(id)
    log text
);
create index logs_idx_id on logs(id);
create index logs_idx_waypoint_id on logs(waypoint_id);

create table containers (
    id integer primary key,
    size text,
    icon integer
);
insert into containers(size, icon) values("Large", 450);
insert into containers(size, icon) values("Micro", 451);
insert into containers(size, icon) values("Not chosen", 452);
insert into containers(size, icon) values("Other", 453);
insert into containers(size, icon) values("Regular", 454);
insert into containers(size, icon) values("Small", 455);
insert into containers(size, icon) values("Virtual", 456);

create table attribute2waypoints (
    id integer primary key,
    waypoint_id integer,		-- points to waypoints(id)
    attribute_id integer,		-- points to attributes(id)
    yes bool
);
create index attribute2waypoints_idx_waypoint_id on attribute2waypoints(waypoint_id);

create table attributes (
    id integer primary key,
    label text,
    gc_id integer,			-- Not a pointer
    icon integer
);
insert into attributes(gc_id, icon, label) values( 0, 500, "Unknown");
insert into attributes(gc_id, icon, label) values( 1, 501, "Dogs Allowed");
insert into attributes(gc_id, icon, label) values( 2, 502, "Access or parking fee");
insert into attributes(gc_id, icon, label) values( 3, 503, "Rock Climbing");
insert into attributes(gc_id, icon, label) values( 4, 504, "Boat");
insert into attributes(gc_id, icon, label) values( 5, 505, "Scuba Gear");
insert into attributes(gc_id, icon, label) values( 6, 506, "Recommended for kids");
insert into attributes(gc_id, icon, label) values( 7, 507, "Takes less than an hour");
insert into attributes(gc_id, icon, label) values( 8, 508, "Scenic view");
insert into attributes(gc_id, icon, label) values( 9, 509, "Significant Hike");
insert into attributes(gc_id, icon, label) values(10, 510, "Difficult climbing");
insert into attributes(gc_id, icon, label) values(11, 511, "May require wading");
insert into attributes(gc_id, icon, label) values(12, 512, "May require swimming");
insert into attributes(gc_id, icon, label) values(13, 513, "Available at all times");
insert into attributes(gc_id, icon, label) values(14, 514, "Recommended at night");
insert into attributes(gc_id, icon, label) values(15, 515, "Available during winter");
insert into attributes(gc_id, icon, label) values(16, 516, "?");
insert into attributes(gc_id, icon, label) values(17, 517, "Poison plants");
insert into attributes(gc_id, icon, label) values(18, 518, "Dangerous Animals");
insert into attributes(gc_id, icon, label) values(19, 519, "Ticks");
insert into attributes(gc_id, icon, label) values(20, 520, "Abandoned mines");
insert into attributes(gc_id, icon, label) values(21, 521, "Cliff / falling rocks");
insert into attributes(gc_id, icon, label) values(22, 522, "Hunting");
insert into attributes(gc_id, icon, label) values(23, 523, "Dangerous area");
insert into attributes(gc_id, icon, label) values(24, 524, "Wheelchair accessible");
insert into attributes(gc_id, icon, label) values(25, 525, "Parking available");
insert into attributes(gc_id, icon, label) values(26, 526, "Public transportation");
insert into attributes(gc_id, icon, label) values(27, 527, "Drinking water nearby");
insert into attributes(gc_id, icon, label) values(28, 528, "Public restrooms nearby");
insert into attributes(gc_id, icon, label) values(29, 529, "Telephone nearby");
insert into attributes(gc_id, icon, label) values(30, 530, "Picnic tables nearby");
insert into attributes(gc_id, icon, label) values(31, 531, "Camping available");
insert into attributes(gc_id, icon, label) values(32, 532, "Bicycles");
insert into attributes(gc_id, icon, label) values(33, 533, "Motorcycles");
insert into attributes(gc_id, icon, label) values(34, 534, "Quads");
insert into attributes(gc_id, icon, label) values(35, 535, "Off-road vehicles");
insert into attributes(gc_id, icon, label) values(36, 536, "Snowmobiles");
insert into attributes(gc_id, icon, label) values(37, 537, "Horses");
insert into attributes(gc_id, icon, label) values(38, 538, "Campfires");
insert into attributes(gc_id, icon, label) values(39, 539, "Thorns");
insert into attributes(gc_id, icon, label) values(40, 540, "Stealth required");
insert into attributes(gc_id, icon, label) values(41, 541, "Stroller accessible");
insert into attributes(gc_id, icon, label) values(42, 542, "Needs maintenance");
insert into attributes(gc_id, icon, label) values(43, 543, "Watch for livestock");
insert into attributes(gc_id, icon, label) values(44, 544, "Flashlight required");
insert into attributes(gc_id, icon, label) values(45, 545, "Lost And Found Tour");
insert into attributes(gc_id, icon, label) values(46, 546, "Truck Driver/RV");
insert into attributes(gc_id, icon, label) values(47, 547, "Field Puzzle");
insert into attributes(gc_id, icon, label) values(48, 548, "UV Torch required");
insert into attributes(gc_id, icon, label) values(49, 549, "Snowshoes");
insert into attributes(gc_id, icon, label) values(50, 550, "Cross Country Skies");
insert into attributes(gc_id, icon, label) values(51, 551, "Special Tool Required");
insert into attributes(gc_id, icon, label) values(52, 552, "Night Cache");
insert into attributes(gc_id, icon, label) values(53, 553, "Park and Grab");
insert into attributes(gc_id, icon, label) values(54, 554, "Abandoned Structure");
insert into attributes(gc_id, icon, label) values(55, 555, "Short hike (less than 1km)");
insert into attributes(gc_id, icon, label) values(56, 556, "Medium hike (1km-10km)");
insert into attributes(gc_id, icon, label) values(57, 557, "Long Hike (+10km)");
insert into attributes(gc_id, icon, label) values(58, 558, "Fuel Nearby");
insert into attributes(gc_id, icon, label) values(59, 559, "Food Nearby");
insert into attributes(gc_id, icon, label) values(60, 560, "WirelessBeacon");
insert into attributes(gc_id, icon, label) values(61, 561, "Partnership Cache");
insert into attributes(gc_id, icon, label) values(62, 562, "Seasonal Access");
insert into attributes(gc_id, icon, label) values(63, 563, "Tourist Friendly");
insert into attributes(gc_id, icon, label) values(64, 564, "Tree Climbing");
insert into attributes(gc_id, icon, label) values(65, 565, "Front Yard");
insert into attributes(gc_id, icon, label) values(66, 566, "Teamwork Required");
insert into attributes(gc_id, icon, label) values(67, 567, "Part of a GeoTour");

create table image2waypoint (
    id integer primary key,
    waypoint_id integer,		-- points to waypoints(id)
    image_id integer,			-- points to images(id)
    type integer			-- 1: log image 2: cache image 3: user image
);
create index image2waypoint_idx_waypoint_id on image2waypoint(waypoint_id);
create index image2waypoint_idx_waypoint_id_type on image2waypoint(waypoint_id, type);

create table images (
    id integer primary key,
    url text,
    filename text,
    datetime integer,
    datafile text
);
create index images_idx_url on images(url);

create table travelbugs (
    id integer primary key,
    gc_id integer,			-- Not a pointer
    ref text,
    name text
);
create index travelbugs_idx_gc_id on travelbugs(gc_id);
create index travelbugs_idx_id on travelbugs(id);

create table bookmarks (
    id integer primary key,
    url text,
    name text
);
create index bookmarks_idx_id on bookmarks(id);

create table travelbug2waypoint (
    id integer primary key,
    travelbug_id integer,		-- points to travelbugs(id)
    waypoint_id integer			-- points to waypoints(id)
);
create index travelbug2waypoint_idx_travelbug_id on travelbug2waypoint(travelbug_id);
create index travelbug2waypoint_idx_cache_id on travelbug2waypoint(waypoint_id);

create table accounts (
    id integer primary key,
    site text,
    url text,
    url_queries text,
    account text,
    password text
);
insert into accounts(site, url, url_queries) values("GroundSpeak Geocaching.com", "https://www.geocaching.com/", "https://www.geocaching.com/pocket/");
insert into accounts(site, url, url_queries) values("Geocaching Australia", "http://www.geocaching.com.au/", "http://geocaching.com.au/my/query/");
insert into accounts(site, url, url_queries) values("OpenCaching BeNeLux", "http://www.opencaching.nl/", "http://www.opencaching.nl/query.php");
insert into accounts(site, url, url_queries) values("OpenCaching North America", "http://www.opencaching.us/", "http://www.opencaching.us/query.php");