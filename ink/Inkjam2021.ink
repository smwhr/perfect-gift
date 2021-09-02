VAR BossIsWaiting = false

VAR KnowPhotoMis = false
VAR HasPhotoMis = false

VAR KnowPhotoWife = false
VAR HasPhotoWife = false

VAR NeedPhoto = false
VAR ShopOpen = true

VAR Gift = "no"

->intro
// ->shop


== intro
# LOCATION: Your office
# PICTURE: office_me

Buzzing intercom

* – Yes ?

– Come in here !
~ BossIsWaiting = true
-
This is your boss calling. His office is west, opposite the corridor. 
(Exits are listed on the top right corner)

- (opts)
+ [exit: West]
    You open the door and gets to the corridor.
    -> office_corridor


== office_corridor

# LOCATION: Corridor
# PICTURE: corridor

West is your boss office. Yours is east.
South the corridor leads to the street exit.

- (opts)
+ [exit: West]
    You enter your boss' office.
    ->office_boss
+ {BossIsWaiting}[exit: East]
    You better hurry. Your boss expects you.
    ->opts
+ {not BossIsWaiting} [exit: East]
    You enter your own office.
    ->office_me
+ {BossIsWaiting}[exit: South]
        Yes, you could quit, just like that.
        But no, you need this job.
        ->opts
+ {not BossIsWaiting}[exit: South]
        You take the stairs down to the street.
    ->street
    


== office_boss
# LOCATION: Your boss' office
# PICTURE: office_boss

{BossIsWaiting:
    You boss is here. He's looking impatient.
    -> initial
-else: 
    -> classic
}

= initial
* – What can I do for you, sir ?
-
– Listen, I need you to find a birthday gift for my wife. We meet for dinner in 2h.
* – And what am [I even supposed to buy for her ?]...
-
Your boss does not have the time to listen to your protesting. He never has. His reply is prompt :

<h3>« You'll think of something. »</h3>
Text and code by Ju/smwhr ©2021
Release 2 / Serial number 290821 / ink 1.0 (inkjs/v2.0)

* [(After all, you always do...)]
-
He hands you his keys. And just like that he's off to a meeting.
You are back in the corridor.
~ BossIsWaiting = false
->office_corridor

= classic
Windows are overlooking a busy parisian street. The desk is immaculate{not HasPhotoMis: except for a single|. There was a} photo of a long-haired blonde woman horse riding{HasPhotoMis: here before}.
~ KnowPhotoWife = true

- (opts)
+ [exit: East]
    You go back to the corridor.
    ->office_corridor
+ {NeedPhoto and not HasPhotoMis} [Take the photograph]
    You take the photograph, the woman from the shop will be happy.
    ~ HasPhotoMis = true
    -> opts

VAR KnowBossAddress = false
== office_me
# LOCATION: Your office
# PICTURE: office_me

This is the smallest room in all the office but at least you have a personal space.
{not KnowBossAddress:
    There's a list of all personel addresses here.
}

-(opts)
+ {not KnowBossAddress}Look over the list
    ~ KnowBossAddress = true
    You find your boss' address : 14 rue Lagrenouille in the 11th arrondissement
    ->opts
+ [exit: West]
    You exit to the corridor.
    ->office_corridor

-> END

== street
# LOCATION: Rue du Temple
# PICTURE: street

You are in a busy parisian street. There are some stores to the south, and the home of your boss is {not KnowBossAddress:somewhere} east.

-(opts)
+ [exit: North]
    You get back to the office.
    ->office_corridor
+ [exit: South]
    You walk south.
    ->panoramas
+ {not KnowBossAddress} [exit: East]
    You don't know the exact address. You're afraid to get lost.
    ->opts
+ {KnowBossAddress} [exit: East]
    You reach the 14 rue Lagrenouille after a 15 minutes walk.
    -> street_door

== street_door
# LOCATION: 14 rue Lagrenouille
# PICTURE: street_door

You are in a very fancy and hipster neighborhood.

-(opts)
+ [exit: West]
    You walk back to Rue du Temple
    ->street
+ [exit: Up]
    Using you boss' key, you let yourself in and climb upstairs.
    ->apartment

== apartment
# LOCATION: 14 rue Lagrenouille (upstairs)
# PICTURE: apartment

This is not your first time here. The apartment is huge but you never went past the vestibule.
On the wall {not KnowPhotoWife: you notice the|there {HasPhotoWife: used to be|is} a} picture of a short-haired, blonde woman, practicing yoga.
~ KnowPhotoWife = true

-(opts)
+ [exit: Down]
    You get back to the street.
    ->street_door
+ {NeedPhoto and not HasPhotoWife} [Take the photograph]
    You take the photograph, the woman from the shop will be happy.
    ~ HasPhotoWife = true
    -> opts


== panoramas
# LOCATION: Passage des Panoramas
# PICTURE: panoramas

You are in Passage des Panoramas. Paris in august : everything is closed {ShopOpen: except for one|even the} strange shop east.

-(opts)
+ {Gift == "no"} [exit: North]
    You get back to your office's street.
    ->street
+ {Gift != "no"} [exit: North]
    -> ending_scene
+ {ShopOpen}[exit: East]
        You enter the shop.
        ->shop
+ {not ShopOpen}[exit: East]
        The shop is now closed.
        ->opts
    
== shop
# LOCATION: Strange shop
# PICTURE: shop
A woman smiles behing the counter.

{shop == 1:
    -> initial
- else:
    -> photo_choice
}
= initial
– What can I do for you ?

+(you) – I want something for me
    -> gift_receive_for("me")
+(wife) – I want something for my boss's wife
            – I need a picture of her
            ~ NeedPhoto = true
            -> photo_choice

= photo_choice
– Did you find a photo ?
-(opts)
* {not HasPhotoWife and not HasPhotoMis} Maybe I can find one on facebook...
    You search but find nothing. 
    ->please_come_back
+ {KnowPhotoMis or KnowPhotoWife and (not HasPhotoMis and not HasPhotoWife)} I know where I can find one...
        -> panoramas
+ {HasPhotoMis} Hand the photo of the woman horse-riding
    -> gift_receive_for("mis")
+ {HasPhotoWife} Hand the photo of the woman practicing yoga
    -> gift_receive_for("wife")
+ {CHOICE_COUNT() == 0}– No...
    -> please_come_back
    

= please_come_back
– Ok, then come back when you do !
    She shows you the door to exit the shop.
    -> panoramas

= gift_receive_for(person)
~ Gift = person
She looks at {person == "me": you|the picture} with intensity and runs to the back shop.
When she comes back she hands you a wrapped package.
– Here, this is the perfect gift.
* – What is it ?
    – I can't tell you, but trust me it is the most perfect gift.
- 
* – How much do I owe you ?
    – Nothing now, come back when it is open and pay me then. Good bye.
    She leads you to the exit and closes the shop behind you.
    ~ ShopOpen = false
- 
-> panoramas


== ending_scene
Your phone rings. This is your boss.
* [Answer]
    – Where are you ?? I'm waiting for you at the restaurant.
- 
* – Let me jump into a cab !
    - The ride is fast.
-

# LOCATION: Restaurant
# PICTURE: restaurant

Your boss is waiting on the curb.
* [Hand over the gift]
    – There it is !
    He takes it without a thank you.
- 

* [Sneak on them]
    You sneak a peak while your boss gets back to its table.
-

{Gift == "mis": You have a bad feeling as you realize the woman sitted in front of him is not the one from the picture you gave earlier.}

{Gift == "wife": 
    The lady is very pleased with the gift.
    Once more, you saved the day.
    }
{Gift == "mis":
    The lady gets suddenly angry, throws wine at your boss and leaves. 
    How will you handle the incident tomorrow ? 
    I guess... you'll think of something !
    }
{Gift == "me":
    The lady looks nonplussed by the gift. But the sellers was right. This is truly the perfect gift for you. 
    How will you take it back ? 
    I guess... you'll think of something !
    }

-
+ [Try something else ? (this will restart the game)]
    # RESTART
    -> END
    