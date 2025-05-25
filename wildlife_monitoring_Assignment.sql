-- Active: 1747413903460@@127.0.0.1@5432@wildlife_monitoring
CREATE DATABASE wildlife_monitoring;

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(100)
)

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT,
    species_id INT,
    sighting_time TIMESTAMP,
    location VARCHAR(250),
    notes TEXT,
    Foreign Key (ranger_id) REFERENCES rangers (ranger_id),
    Foreign Key (species_id) REFERENCES species (species_id)
);

-- data insert
INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- Query's
-- problem 1 - Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');
-- problem 2 - Count unique species ever sighted.
SELECT count(DISTINCT species_id) as unique_species_count
FROM sightings;
-- problem 3 - Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location ILIKE '%Pass%';
-- problem 4 - List each ranger's name and their total number of sightings.
SELECT r.name, count(*) AS total_sightings
FROM sightings AS s
    INNER JOIN rangers AS r ON r.ranger_id = s.ranger_id
GROUP BY
    r.name;
-- problem 5 - List species that have never been sighted.
SELECT sp.common_name
FROM species as sp
    LEFT JOIN sightings AS si ON sp.species_id = si.species_id
WHERE
    si.species_id IS NULL;
-- problem 6 - Show the most recent 2 sightings.
SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings AS s
    INNER JOIN species AS sp ON s.species_id = sp.species_id
    INNER JOIN rangers AS r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- problem 7- Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    extract(
        YEAR
        from species.discovery_date
    ) < 1800;
-- problem 8 - Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
-- Morning: before 12 PM
-- Afternoon: 12 PM–5 PM
-- Evening: after 5 PM
SELECT
    sighting_id,
    CASE
        WHEN extract(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN extract(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- problem 9 - Delete rangers who have never sighted any species
DELETE FROM rangers AS r
WHERE
    r.ranger_id NOT IN (
        SELECT DISTINCT
            s.ranger_id
        FROM sightings AS s
    );

------------------------------
SELECT * FROM rangers;

SELECT * FROM species;

SELECT * FROM sightings;