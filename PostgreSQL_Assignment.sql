
-- creating data tables  

Create table rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
)

Create Table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
)

Create Table sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL REFERENCES rangers(ranger_id),
    species_id INT NOT NULL REFERENCES species(species_id),
    sighting_time TIMESTAMP  NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT
);









-- insertation of first data set 

Insert INTO rangers (name, region) VALUES 
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

Insert INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES 
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');



INSERT INTO sightings (ranger_id, species_id,location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- drop table rangers;
-- drop table sightings;
-- drop table species;


SELECT * from rangers;
SELECT * from species;
SELECT * from sightings;



-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT into rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains');






--2️⃣ Count unique species ever sighted.

Select count(distinct species_id) as unique_species_count from sightings;






-- 3️⃣ Find all sightings where the location includes "Pass".

SELECT * from sightings Where location LIKE '%Pass%';




-- 4️⃣ List each ranger's name and their total number of sightings.


SELECT name , count(sighting_id) as total_sightings  from rangers JOIN sightings
on rangers.ranger_id = sightings.ranger_id
GROUP BY name;






-- 5️⃣ List species that have never been sighted.

SELECT common_name 
FROM species left  JOIN sightings
ON species.species_id = sightings.species_id
GROUP BY common_name
HAVING COUNT(sighting_id) =0;





-- 6️⃣ Show the most recent 2 sightings.

Select common_name, sighting_time, name 
FROM sightings
JOIN species ON sightings.species_id = species.species_id
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
Order by sighting_time DESC
LIMIT 2;




-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.

Update species 
Set conservation_status = 'Historic'
where extract(year from discovery_date) < 1800;






-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

Select sighting_id, 
case 
    when extract(hour from sighting_time)<12 then 'Morning'
    when extract(hour from sighting_time) BETWEEN 12 AND 16  then 'Afternoon'
    else 'Evening'
    end as time_of_day
    from sightings;




-- 9️⃣ Delete rangers who have never sighted any species
DELETE FROM
 rangers WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);


