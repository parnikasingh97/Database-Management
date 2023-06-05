/* 
1. Extracting location of the store and the information on the managers.  
*/ 

SELECT 
	staff.first_name AS manager_first_name, 
    staff.last_name AS manager_last_name,
    address.address, 
    address.district, 
    city.city, 
    country.country

FROM store
	LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
    LEFT JOIN address ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id
;
	
/*
2.	Extracting the information on the inventory
*/

SELECT 
	inventory.store_id, 
    inventory.inventory_id, 
    film.title, 
    film.rating, 
    film.rental_rate, 
    film.replacement_cost
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
;

/* 
Pulling out the ratings of the inventory items
*/

SELECT 
	inventory.store_id, 
    film.rating, 
    COUNT(inventory_id) AS inventory_items
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
GROUP BY 
	inventory.store_id,
    film.rating
;

/* 
Pulling out the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

SELECT 
	store_id, 
    category.name AS category, 
	COUNT(inventory.inventory_id) AS films, 
    AVG(film.replacement_cost) AS avg_replacement_cost, 
    SUM(film.replacement_cost) AS total_replacement_cost
    
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
	LEFT JOIN film_category
		ON film.film_id = film_category.film_id
	LEFT JOIN category
		ON category.category_id = film_category.category_id

GROUP BY 
	store_id, 
    category.name
    
ORDER BY 
	SUM(film.replacement_cost) DESC
;

/*
Pulling a list of all customer names, which store they go to, whether or not they are currently active,  
and their full addresses – street address, city, and country. 
*/

SELECT 
	customer.first_name, 
    customer.last_name, 
    customer.store_id,
    customer.active, 
    address.address, 
    city.city, 
    country.country

FROM customer
	LEFT JOIN address ON customer.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id
;

/*
Extracting a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. 
*/

SELECT 
	customer.first_name, 
    customer.last_name, 
    COUNT(rental.rental_id) AS total_rentals, 
    SUM(payment.amount) AS total_payment_amount

FROM customer
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
    LEFT JOIN payment ON rental.rental_id = payment.rental_id

GROUP BY 
	customer.first_name,
    customer.last_name

ORDER BY 
	SUM(payment.amount) DESC
    ;
    
/*
Creating a new table for investors and advisors. 
*/

SELECT
	'investor' AS type, 
    first_name, 
    last_name, 
    company_name
FROM investor

UNION 

SELECT 
	'advisor' AS type, 
    first_name, 
    last_name, 
    NULL
FROM advisor;

/*
Extracting which actor got how many and which type of awards. 
*/

SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
	
FROM actor_award
	

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END





