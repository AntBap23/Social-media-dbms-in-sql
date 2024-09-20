PRAGMA foreign_keys = ON;

-- Users table
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL,
    fullname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    pfp TEXT NOT NULL,  -- Changed from BLOB to TEXT
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Posts table
CREATE TABLE Posts (
    post_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Comments table
CREATE TABLE Comments (
    comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    com_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    likes INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Likes table
CREATE TABLE Likes (
    like_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    comment_id INTEGER,
    like_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (comment_id) REFERENCES Comments(comment_id)
);

-- Shares table
CREATE TABLE Shares (
    share_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    share_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Follows table
CREATE TABLE Follows (
    follower_id INTEGER NOT NULL,
    following_id INTEGER NOT NULL,
    follow_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id),
    FOREIGN KEY (following_id) REFERENCES Users(user_id)
);
-- Enable foreign key enforcement
PRAGMA foreign_keys = ON;

-- Trigger to increment the 'likes' column in the 'Comments' table when a like is added to a comment
CREATE TRIGGER increment_comment_likes
AFTER INSERT ON Likes
WHEN NEW.comment_id IS NOT NULL
BEGIN
   UPDATE Comments
   SET likes = likes + 1
   WHERE comment_id = NEW.comment_id;
END;

-- Trigger to prevent a user from following themselves
CREATE TRIGGER prevent_self_follow
BEFORE INSERT ON Follows
WHEN NEW.follower_id = NEW.following_id
BEGIN
   SELECT RAISE(ABORT, 'Users cannot follow themselves.');
END;

-- Trigger to automatically remove all associated likes when a post is deleted
CREATE TRIGGER delete_likes_on_post_delete
AFTER DELETE ON Posts
BEGIN
   DELETE FROM Likes WHERE post_id = OLD.post_id;
END;

-- Trigger to automatically remove all associated comments when a post is deleted
CREATE TRIGGER delete_comments_on_post_delete
AFTER DELETE ON Posts
BEGIN
   DELETE FROM Comments WHERE post_id = OLD.post_id;
END;

-- Trigger to automatically remove all associated likes when a comment is deleted
CREATE TRIGGER delete_likes_on_comment_delete
AFTER DELETE ON Comments
BEGIN
   DELETE FROM Likes WHERE comment_id = OLD.comment_id;
END;


INSERT INTO Users (user_id, username, fullname, email, password, pfp, date_joined) VALUES 
 ('1','CodingNinja','Alex Riley','coffeejunkie99@mail.com','SkyWalker2021!','mystic_wolf_01.jpg','2/11/2023 14:22'), 
 ('2','TechWizard','Emily Carter','pixelwizard2024@webmail.com','PurplePanda#88','galaxy_dreamer_42.jpg','6/3/2022 9:44'), 
 ('3','GamerGirl','Noah Davis','wanderlust_vibes@mail.com','Moonlight$Dreamer42','neon_ninja_77.jpg','12/25/2023 16:15'), 
 ('4','Bookworm','Olivia Baker','code_master101@mail.com','CoffeeNinja!777','pixel_knight_101.jpg','11/8/2022 8:39'), 
 ('5','CoffeeLover','Ethan Miller','rainbowunicorn84@mail.com','TechSavvy%99','cosmic_fox_88.jpg','1/17/2023 21:58'), 
 ('6','FoodieFan','Ava Johnson','cosmicdreamer42@mail.com','GalacticTiger@123','bubble_tea_lover.jpg','9/12/2022 10:34'), 
 ('7','TravelBug','Jacob Lee','bookdragon2021@webmail.com','PixelPixie#01','silent_storm_999.jpg','3/7/2023 18:13'), 
 ('8','NatureLover','Sophia King','quietstorm987@mail.com','SilentStorm$45','blazing_dragon_24.jpg','7/21/2023 23:11'), 
 ('9','MovieGeek','Mason Wilson','starlightwhisper@mail.com','CosmicFox_21','turbo_tiger_555.jpg','10/5/2021 5:48'), 
 ('10','MusicFan','Isabella Taylor','crypticcat22@webmail.com','NeonKnight#77','retro_gamer_2022.jpg','4/16/2023 7:56'), 
 ('11','A1B2C3','Benjamin Harris','pancake_ninja777@mail.com','BubbleTea_Lover88','starry_sky_101.jpg','3/23/2022 2:07'), 
 ('12','XYZ123','Emma Young','neonpantherx@mail.com','GuitarHero$555','pixel_rainbow_11.jpg','8/28/2023 19:09'), 
 ('13','SuperHero','Elijah Brown','donutlover_24@mail.com','WhisperWolf!99','cosmic_tiger_77.jpg','5/29/2023 13:37'), 
 ('14','GalaxyQuest','Abigail Clark','pixel_hero21@webmail.com','CodeMaster@999','thunder_cloud_98.jpg','6/13/2023 12:44'), 
 ('15','OceanDream','Aiden Jones','curiousfox555@mail.com','SolarFlare%84','dragon_rider_42.jpg','12/2/2021 22:22'), 
 ('16','MountainHigh','Chloe Smith','guitar_riff96@webmail.com','DragonFire#42','quiet_night_84.jpg','7/19/2022 11:08'), 
 ('17','DesertStorm','Lucas Johnson','stormchaser88@mail.com','CyberBear!121','ninja_penguin_64.jpg','9/27/2023 4:29'), 
 ('18','ForestFriend','Mia Davis','caffeinequeen101@mail.com','MagicMuffin$33','moonlight_shadow_22.jpg','10/23/2022 9:19'), 
 ('19','JungleAdventure','Oliver Wilson','zenith_spark@webmail.com','PixelWarrior_21','blazing_phoenix_999.jpg','3/31/2023 14:01'), 
 ('20','ArcticExplorer','Lily Baker','panda_pilot@mail.com','ThunderCloud!89','tech_master_88.jpg','11/14/2021 6:33'), 
 ('21','PixelatedPoet','Charlotte Lee','codegeek456@webmail.com','CaffeineKing#2024','pixel_panda_21.jpg','7/1/2023 20:46'), 
 ('22','DigitalDreamer','Sophia Carter','moonlitwave@mail.com','NinjaPenguin_98','electric_eagle_55.jpg','5/5/2022 0:12'), 
 ('23','CloudSurfer','Amelia Johnson','dragonfly_chaser@webmail.com','GalaxyHunter@66','coffee_ninja_2021.jpg','12/28/2021 17:20'), 
 ('24','MoonlightMapper','Evelyn Miller','electricowl12@mail.com','MysticMoon%888','turbo_koala_77.jpg','4/18/2022 3:53'), 
 ('25','StarryEyed','Abigail Davis','blazingphoenix7@mail.com','TurboTiger$11','galactic_unicorn_66.jpg','10/9/2023 18:55'), 
 ('26','SunKissed','Harper Wilson','cloudwalker88@webmail.com','IceCream_Coder21','pixel_mage_33.jpg','9/9/2021 22:45'), 
 ('27','RainbowBright','Elizabeth Lee','thunder_wolf21@mail.com','BlazingStar$999','nebula_knight_555.jpg','8/14/2022 11:26'), 
 ('28','FireflyFlash','Olivia Baker','sunshine_sketcher@mail.com','ZephyrWind!77','mystic_turtle_999.jpg','1/2/2023 15:35'), 
 ('29','MidnightMuse','Emma Johnson','midnightowl99@mail.com','DancingRobot_64','zen_master_84.jpg','10/29/2021 7:21'), 
 ('30','AuroraBorealis','Ava Davis','bubble_tea_tiger@webmail.com','CosmicTide@999','thunder_wolf_24.jpg','11/17/2023 19:43'), 
 ('31','AlphaBravoCharlie','Henry Miller','pixelwizard2021@webmail.com','QuietNight_42','ninja_coder_888.jpg','2/7/2023 9:57'), 
 ('32','DeltaEchoFoxtrot','Evelyn Jones','crimson_star66@mail.com','PhoenixFire$99','silent_whisper_42.jpg','12/13/2022 4:41'), 
 ('33','GolfHotelIndia','Elijah Smith','silent_night777@webmail.com','RetroGamer#55','blazing_sun_777.jpg','6/25/2021 2:36'), 
 ('34','JulietKiloLima','Abigail Baker','galaxy_traveler98@mail.com','WandererSoul@84','cosmic_mermaid_101.jpg','9/1/2022 23:53'), 
 ('35','MikeNovemberOscar','Aiden Wilson','rhythm_dancer24@mail.com','DragonFly_88','turbo_dragon_999.jpg','5/11/2023 13:27'), 
 ('36','PapaQuebecRomeo','Chloe Johnson','magicmuffin88@webmail.com','StarGazer$222','pixel_guardian_22.jpg','3/26/2023 12:51'), 
 ('37','SierraTangoUniform','Lucas Lee','quirky_koala14@mail.com','Eclipse$Shadow92','shadow_knight_89.jpg','10/2/2022 8:17'), 
 ('38','VictorWhiskeyXray','Olivia Carter','dancingrobot99@mail.com','MoonlitWave_2022','moon_rider_555.jpg','7/7/2021 6:14'), 
 ('39','YankeeZulu01','Oliver Davis','pixelpixie123@webmail.com','RocketRider#77','dragonfly_chaser_11.jpg','4/9/2023 19:58'), 
 ('40','AlphabeticalOrder','Mia Baker','candycloud22@mail.com','CloudChaser_19','neon_wave_88.jpg','11/19/2022 15:49'), 
 ('41','NumberOneFan','Jacob Davis','blazingdragon25@webmail.com','BlazingEagle$555','storm_chaser_44.jpg','11/1/2021 4:06'), 
 ('42','TwoTimesTwo','Sophia Miller','techjunkie89@mail.com','SilentKnight_01','pixel_phoenix_77.jpg','6/6/2023 11:33'), 
 ('43','ThreeAmigos','Noah Johnson','ninja_penguin42@mail.com','NinjaCoder!123','panda_pilot_555.jpg','3/11/2022 7:42'), 
 ('44','FourSeasons','Olivia Baker','electric_koala23@mail.com','PandaQueen_89','mystic_hawk_2022.jpg','8/9/2023 23:05'), 
 ('45','FiveStars','Ethan Wilson','galaxy_rider98@webmail.com','ThunderBolt_77','cyber_tiger_101.jpg','7/12/2023 9:27'), 
 ('46','SixSenses','Ava Lee','midnight_sun99@mail.com','CosmicSailor#66','thunder_raven_999.jpg','1/22/2023 14:53'), 
 ('47','SevenSeas','Elijah Carter','pixel_rainbow77@webmail.com','StarrySky_94','pixel_genius_42.jpg','8/26/2021 1:19'), 
 ('48','EightBall','Amelia Smith','silent_scribe88@mail.com','CoderGenius#101','ninja_warrior_21.jpg','9/12/2023 18:24'), 
 ('49','NineLives','Lucas Johnson','wanderlust_wave91@mail.com','ElectricWolf$88','blazing_bear_555.jpg','7/27/2022 3:50'), 
 ('50','TenFingers','Mia Davis','zenmaster_101@mail.com','JellyBean_123','retro_robot_77.jpg','2/24/2023 6:39'), 
 ('51','StardustSailor','Benjamin Baker','flamingtiger45@mail.com','BlazeHawk!99','electric_raccoon_22.jpg','5/22/2022 22:08'), 
 ('52','NebulaNavigator','Emma Wilson','mystic_harmony21@webmail.com','PixelWizard#23','cosmic_owl_999.jpg','9/18/2021 16:43'), 
 ('53','CometCommander','Elijah Carter','neon_raccoon64@mail.com','CyberSamurai$555','pixel_hero_44.jpg','4/28/2023 5:23'), 
 ('54','GalaxyGuardian','Abigail Davis','stormhunter97@mail.com','NebulaKnight!84','nebula_panda_88.jpg','10/17/2021 14:29'), 
 ('55','SolarSystemSeeker','Aiden Johnson','shadowwhisper25@webmail.com','ShinyTurtle_21','galaxy_rider_101.jpg','2/8/2022 0:17'), 
 ('56','PlanetPioneer','Chloe Lee','cosmic_mermaid91@mail.com','CrimsonPhoenix#555','pixel_dreamer_55.jpg','12/4/2023 16:37'), 
 ('57','AsteroidAdventurer','Lucas Miller','spacetraveler101@mail.com','NinjaRider@101','mystic_wolf_999.jpg','5/10/2021 20:41'), 
 ('58','MeteoriteMapper','Olivia Baker','dragon_rider_84@webmail.com','PandaWarrior_24','dragonfire_hero_24.jpg','8/2/2022 19:06'), 
 ('59','Moonwalker','Oliver Wilson','pixelgenius42@mail.com','PixelDreamer$33','thunder_falcon_2021.jpg','5/15/2023 1:45'), 
 ('60','SpaceExplorer','Mia Carter','turtle_power777@mail.com','TurboFox!888','pixel_pirate_42.jpg','11/28/2021 7:03'), 
 ('61','A123456','Noah Davis','turbofox44@webmail.com','ShadowCat#101','cosmic_knight_555.jpg','6/11/2022 5:55'), 
 ('62','B78901','Olivia Baker','silverarrow2022@mail.com','SolarFlare_42','neon_panther_88.jpg','7/29/2023 2:56'), 
 ('63','CDE456','Ethan Miller','codecraze777@webmail.com','CodeCrusader!21','storm_shadow_777.jpg','9/5/2021 21:10'), 
 ('64','FGHIJK','Ava Johnson','candy_crusher91@mail.com','BlazingDragon_99','bubble_bee_101.jpg','3/31/2022 13:22'), 
 ('65','LMNO12','Jacob Lee','glitched_unicorn@mail.com','NeonRainbow$88','pixel_vibes_999.jpg','8/21/2023 17:31'), 
 ('66','PQRSTU','Sophia Carter','phantom_tiger23@webmail.com','CyberFalcon_77','galactic_racer_66.jpg','12/20/2022 6:42'), 
 ('67','VWXYZ0','Elijah Smith','pixel_ninja96@mail.com','MysticRider#24','electric_wizard_42.jpg','10/10/2021 4:26'), 
 ('68','ABCDEF1','Abigail Wilson','cyber_wolf42@mail.com','TwilightTiger@555','mystic_panther_21.jpg','11/8/2023 3:53'), 
 ('69','GHIKLM2','Aiden Baker','moonlight_runner@webmail.com','NinjaVibes#89','cyber_fox_555.jpg','4/4/2022 2:33'), 
 ('70','NOPQRS3','Chloe Johnson','blaze_hawk91@mail.com','StormChaser_888','moonlight_owl_101.jpg','6/18/2023 22:11'), 
 ('71','MM12345678','Lucas Carter','sunset_racer77@webmail.com','MagicCheetah!77','pixel_ninja_999.jpg','6/14/2021 15:08'), 
 ('72','KO34691847','Amelia Wilson','retro_rocket42@mail.com','BubbleBee_999','thunder_rider_22.jpg','7/2/2022 18:04'), 
 ('73','ABCDEFGH','Oliver Baker','frozen_dreamer99@webmail.com','CrystalMoon_2022','silent_scribe_88.jpg','9/3/2023 11:45'), 
 ('74','IJKLMNO','Mia Johnson','pixel_rider21@mail.com','PhoenixRider!999','blazing_unicorn_555.jpg','10/29/2022 1:31'), 
 ('75','PQRSTUVW','Ethan Davis','zephyr_night88@mail.com','TurboCheetah$84','cosmic_racer_42.jpg','12/16/2021 20:36'), 
 ('76','XYZ12345','Ava Lee','cosmic_storm77@webmail.com','CoderBear@101','dragon_runner_77.jpg','3/14/2023 17:27'), 
 ('77','ABCDE123','Jacob Smith','code_breeze91@mail.com','PixelTiger_44','turbo_eagle_101.jpg','5/28/2022 12:24'), 
 ('78','FGHIJK45','Sophia Carter','fiery_unicorn55@webmail.com','MoonlitKnight$123','pixel_mage_33.jpg','11/21/2021 5:19'), 
 ('79','LMNO1234','Elijah Miller','cyber_falcon42@mail.com','SilverArrow!88','nebula_dreamer_999.jpg','1/29/2023 9:47'), 
 ('80','PQRSTU56','Abigail Wilson','nebula_rider96@webmail.com','ShadowNinja_2021','galaxy_hunter_2022.jpg','6/20/2022 3:07'), 
 ('81','PixelPerfect','Benjamin Wilson','ocean_wave101@mail.com','BlazingWolf$777','electric_koala_77.jpg','10/19/2023 15:11'), 
 ('82','DigitalDiva','Emma Baker','radiant_hawk42@mail.com','SilentMoon@999','pixel_whale_555.jpg','9/24/2022 13:48'), 
 ('83','CloudCruiser','Noah Carter','turbo_coder21@webmail.com','CaffeineKing_55','thunder_penguin_44.jpg','2/16/2023 18:36'), 
 ('84','MoonlightMystic','Olivia Davis','mysticfox89@mail.com','CosmicUnicorn_42','cosmic_knight_101.jpg','11/4/2022 8:40'), 
 ('85','StarrySky','Ethan Johnson','shadow_falcon23@webmail.com','PixelGuardian#2022','ninja_turtle_999.jpg','5/6/2023 22:15'), 
 ('86','SunSeeker','Ava Lee','moonbeam_coder@webmail.com','NebulaRider_77','blazing_raven_88.jpg','2/26/2022 9:03'), 
 ('87','RainbowRider','Jacob Miller','dragon_warrior44@mail.com','TurboPanda!2024','pixel_wizard_55.jpg','7/6/2023 23:50'), 
 ('88','FireflyFriend','Sophia Smith','cyber_moon77@mail.com','MysticWave$89','silent_panther_42.jpg','8/18/2022 4:39'), 
 ('89','MidnightMaiden','Elijah Baker','pixelstorm92@webmail.com','CrimsonWolf@2022','cosmic_unicorn_999.jpg','7/23/2021 2:22'), 
 ('90','AuroraAdept','Abigail Wilson','cosmic_dreamer21@mail.com','PixelRain#101','turbo_fox_21.jpg','4/4/2023 15:31'), 
 ('91','q12345678','Lucas Davis','solar_rider101@mail.com','StormRider_555','pixel_sky_77.jpg','12/8/2022 21:12'), 
 ('92','9Z876543','Mia Baker','cyberwave999@mail.com','StarLight$88','nebula_wolf_555.jpg','3/20/2023 7:52'), 
 ('93','ABCDEFGH','Oliver Carter','storm_raven45@webmail.com','ShinyDragon_44','galaxy_rider_88.jpg','9/28/2021 11:09'), 
 ('94','IJKLMNO','Amelia Wilson','pixelmage84@mail.com','MysticMoon!101','cyber_hero_101.jpg','3/5/2022 23:04'), 
 ('95','PQRSTUVW','Ethan Johnson','neon_horizon55@webmail.com','BlazeRunner@2021','pixel_mermaid_999.jpg','11/30/2023 10:59'), 
 ('96','XYZ12345','Ava Lee','glitch_fox21@mail.com','SilentFalcon$88','thunder_pirate_24.jpg','6/1/2021 13:27'), 
 ('97','ABCDE123','Jacob Miller','blazingwolf88@webmail.com','ThunderFox_777','mystic_rider_555.jpg','10/14/2022 18:19'), 
 ('98','FGHIJK45','Sophia Smith','midnightwhisper77@mail.com','GalacticKnight!2022','moonlight_hawk_2021.jpg','9/15/2023 5:45'), 
 ('99','LMNO1234','Elijah Baker','digitaldragon42@mail.com','NeonWave_555','pixel_knight_66.jpg','6/29/2022 3:28'), 
 ('100','PQRSTU56','Abigail Wilson','pixel_muse101@mail.com','CyberTiger$999','galaxy_phoenix_88.jpg','1/12/2023 8:38');
);



