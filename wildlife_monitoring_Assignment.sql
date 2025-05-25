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
    Foreign Key (ranger_id) REFERENCES rangers(ranger_id),
    Foreign Key (species_id) REFERENCES species(species_id)
);


