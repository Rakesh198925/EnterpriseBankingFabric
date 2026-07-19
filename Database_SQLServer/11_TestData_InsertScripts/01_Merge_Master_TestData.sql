MERGE Master.CountryMaster AS Target

USING
(
VALUES

('AT','Austria','AUT','EUR'),
('BE','Belgium','BEL','EUR'),
('DE','Germany','DEU','EUR'),
('FR','France','FRA','EUR'),
('LU','Luxembourg','LUX','EUR'),
('NL','Netherlands','NLD','EUR'),
('IN','India','IND','INR'),
('US','United States','USA','USD')

)
AS Source
(
CountryCode,
CountryName,
ISOCode3,
CurrencyCode
)


ON Target.CountryCode = Source.CountryCode


WHEN MATCHED THEN

UPDATE SET

CountryName = Source.CountryName,
ISOCode3 = Source.ISOCode3,
CurrencyCode = Source.CurrencyCode,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = 'Rakesh'


WHEN NOT MATCHED THEN

INSERT
(
CountryCode,
CountryName,
ISOCode3,
CurrencyCode,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
Source.CountryCode,
Source.CountryName,
Source.ISOCode3,
Source.CurrencyCode,
1,
SYSUTCDATETIME(),
'Rakesh'
);


GO