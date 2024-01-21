
/* 

Data Exploration

*/


--Overview
Select *
From PortfolioProject.dbo.[Copy listings detailed]

--the number of property in each category: 54
Select distinct count(id) as number_of_units, property_type
From PortfolioProject.dbo.[Copy listings detailed]
--where property_type Like 'Entire%'
group by property_type


--Properties with a 5 star review: 2207
Select id, property_type, name, neighbourhood_cleansed, bedrooms
From PortfolioProject.dbo.[Copy listings detailed]
where (review_scores_rating=5) and (property_type Like 'Entire%')


--how many properties does a superhot have
Select distinct host_name, name, property_type, host_total_listings_count
From PortfolioProject.dbo.[Copy listings detailed]
where host_is_superhost='t'
order by host_name


--Properties with long term rental
Select count(id) as number_of_units, property_type
From PortfolioProject.dbo.[Copy listings detailed]
where minimum_nights>30
group by property_type



--Properties with short term rental
Select count(id) as number_of_units, property_type
From PortfolioProject.dbo.[Copy listings detailed]
where (maximum_nights<100)
group by property_type


-- unit price for the night for short term rentals
Select name, property_type, price, bedrooms, minimum_nights ,maximum_nights, neighbourhood_cleansed
From PortfolioProject.dbo.[Copy listings detailed]
where maximum_nights<100 and minimum_nights<=7
order by price desc


/*

   Data Cleaning

*/


--last_scraped column converted

Select CONVERT(Date,last_scraped)
From PortfolioProject.dbo.[Copy listings detailed]

ALTER TABLE PortfolioProject.dbo.[Copy listings detailed]
Add last_scrapedConverted Date;

Update PortfolioProject.dbo.[Copy listings detailed]
SET last_scrapedConverted = CONVERT(Date,last_scraped)



-- Host_since column converted
ALTER TABLE PortfolioProject.dbo.[Copy listings detailed]
Add host_sinceConverted Date;

Update PortfolioProject.dbo.[Copy listings detailed]
SET host_sinceConverted = CONVERT(Date,host_since)



-- first_review column converted
ALTER TABLE PortfolioProject.dbo.[Copy listings detailed]
Add first_reviewConverted Date;

Update PortfolioProject.dbo.[Copy listings detailed]
SET first_reviewConverted = CONVERT(Date,first_review)



-- last_review column converted
ALTER TABLE PortfolioProject.dbo.[Copy listings detailed]
Add last_reviewConverted Date;

Update PortfolioProject.dbo.[Copy listings detailed]
SET last_reviewConverted = CONVERT(Date,last_review)

-- 
Select *
From PortfolioProject.dbo.[Copy listings detailed]


-- new listings VS old listings
--new listings View
create OR alter view new_listings 
as
	Select first_reviewConverted, review_scores_rating, property_type,name , neighbourhood_cleansed
	From PortfolioProject.dbo.[Copy listings detailed]
	where first_reviewConverted >= '2021-01-01'
	
go


--old listings View
create OR alter view old_listings 
as 
	Select first_reviewConverted, review_scores_rating, property_type, name, neighbourhood_cleansed
	From PortfolioProject.dbo.[Copy listings detailed]
	where first_reviewConverted <= '2021-01-01'
	 ;
go


-- old listings which have 5 star review: 1420
select first_reviewConverted, property_type, review_scores_rating, name, neighbourhood_cleansed
From old_listings
where review_scores_rating=5

-- new listings which have 5 star review: 1519
select first_reviewConverted, property_type, review_scores_rating, name, neighbourhood_cleansed
From new_listings
where review_scores_rating=5


--not a superhost who has a house with a 3-4 bedrooms: 1186 ( target )
select distinct host_name, property_type, bedrooms,name , neighbourhood_cleansed, 
bedrooms, review_scores_rating
From PortfolioProject.dbo.[Copy listings detailed]
where (host_is_superhost='f') and (bedrooms between 3 and 4) and ( property_type Like 'Entire%' )
and ( review_scores_rating <= 4 )
order by host_name


-- active units : 200
select last_reviewConverted, number_of_reviews_l30d, name, property_type
From PortfolioProject.dbo.[Copy listings detailed]
where number_of_reviews_l30d > 5
order by last_reviewConverted desc


Select *
From PortfolioProject.dbo.[Copy listings detailed]


-- availibility for the last 30 & 60 days
Select availability_30, availability_60, availability_90, name, property_type
From PortfolioProject.dbo.[Copy listings detailed]
where ( availability_30 between 2 and 14 ) and ( property_type Like 'Entire%' )
order by availability_30 


