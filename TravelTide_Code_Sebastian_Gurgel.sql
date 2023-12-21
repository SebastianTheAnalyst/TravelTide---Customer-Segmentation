/*Customer Level Data */

-- Select specific columns for analysis on a customer Level
SELECT
    u.user_id,                                      -- User ID
    sign_up_date,                                   -- Date of user sign-up
    gender,                                         -- Gender
    married,                                        -- Marital status
    has_children,                                   -- Presence of children
    home_country,                                   -- Home country
    home_city,                                      -- Home city
    MAX(session_start) as last_session_start,       -- Most recent session start time
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) AS age,  -- Calculate age based on birthdate
    COUNT(session_id) as number_of_sessions,         -- Count of sessions
    ROUND(AVG(page_clicks)) As avg_page_clicks,      -- Average page clicks per session
    ROUND(AVG(EXTRACT(EPOCH FROM session_end - session_start) / 60.0), 1) AS avg_session_length_minutes, -- Average session length in minutes
    ROUND(EXTRACT(EPOCH FROM CURRENT_DATE - MAX(session_start)) / (24.0 * 60.0 * 60.0)) AS recent_session,  -- Days since last session
    COUNT(s.trip_id) AS number_of_trips,             -- Count of total trips
    COUNT(f.trip_id) AS number_of_flights,           -- Count of flights taken
    COUNT(h.trip_id) AS number_of_hotels,            -- Count of hotels stayed
    ROUND(count(CASE WHEN s.cancellation = 'true' THEN 1 ELSE NULL END)) AS num_cancellations,  -- Count of cancellations
    ROUND( COUNT(CASE WHEN s.cancellation = 'true' THEN 1 ELSE NULL END) * 1.0 / NULLIF(COUNT(s.trip_id), 0), 1) AS trips_cancellations_ratio, -- Ratio of cancellations to trips
    ROUND(AVG(CASE WHEN seats <> 0 THEN seats ELSE NULL END)) as avg_seats,  -- Average number of seats booked
    ROUND(AVG(checked_bags)) as avg_checked_bags,   -- Average number of checked bags
    ROUND(CAST(AVG(haversine_distance(home_airport_lat, home_airport_lon, destination_airport_lat, destination_airport_lon)) AS numeric), 2) AS avg_distance_km, -- Average haversine distance traveled in kilometers
    ROUND(AVG(flight_discount_amount),2) as avg_flight_discount_amount,  -- Average flight discount amount
    ROUND(AVG(CASE WHEN base_fare_usd <> 0 THEN base_fare_usd END), 2) as avg_base_fare,  -- Average base fare
    ROUND(AVG(hotel_discount_amount),2) as avg_hotel_discount_amount,  -- Average hotel discount amount
    ROUND(AVG(CASE WHEN flight_discount_amount IS NOT NULL AND flight_discount_amount <> 0
                    THEN base_fare_usd * flight_discount_amount
                    ELSE base_fare_usd END),2) AS avg_flight_total_usd,  -- Average total flight cost with discounts
    SUM(CASE WHEN s.flight_discount THEN 1 ELSE 0 END) :: FLOAT / COUNT(*) AS discount_flight_proportion,  -- Proportion of flights with discounts
    ROUND(AVG(base_fare_usd*flight_discount_amount),2) AS ADS,  -- Average discount savings
    SUM(base_fare_usd*flight_discount_amount)/SUM(haversine_distance(home_airport_lat, home_airport_lon, destination_airport_lat, destination_airport_lon)) AS ADS_per_km,  -- Average discount savings per kilometer traveled
    ROUND(AVG(CASE WHEN hotel_discount_amount IS NOT NULL AND hotel_discount_amount <> 0
                    THEN hotel_per_room_usd * rooms * hotel_discount_amount
                    ELSE hotel_per_room_usd END),2) AS avg_hotel_total_usd,  -- Average total hotel cost with discounts
    SUM(CASE WHEN s.hotel_discount THEN 1 ELSE 0 END) :: FLOAT / COUNT(*) AS discount_hotel_proportion,  -- Proportion of hotels with discounts
    ROUND(AVG(EXTRACT(EPOCH FROM check_out_time - check_in_time) / (24.0 * 60.0 * 60.0))) AS avg_hotel_length  -- Average hotel stay length in days

   
 /* 
 This query will only include rows for customers who had more than 7 sessions in the sessions table. 
Other customers will be excluded from the results. 
The subquery is used to filter the user_id based on the condition of having more than 7 sessions in the same time period.
 The main query then retrieves all the data for those users from the users-, sessions-, flights-, and hotels-tables. */

-- Combine data from different tables using JOINs
FROM sessions s
JOIN users u ON s.user_id = u.user_id
LEFT JOIN flights f ON s.trip_id = f.trip_id
LEFT JOIN hotels h ON s.trip_id = h.trip_id

-- Filter data based on specified conditions
WHERE (session_start >= '2023-01-04' 
    AND u.user_id IN (
            -- Select user IDs with a minimum number of sessions
            SELECT user_id
            FROM sessions
            WHERE session_start >= '2023-01-04' 
            GROUP BY user_id
            HAVING COUNT(session_start) > 7))

/* that would be the Outlier Filter, I used on the joined Dataset in PGAdmin4*/
--AND base_fare_usd < 6194
--AND page_clicks < 279
--AND hotel_per_room_usd < 932
--AND nights < 35

-- Group the results by user ID for summary statistics
GROUP BY u.user_id
-- Order the results by user ID
ORDER BY user_id;
