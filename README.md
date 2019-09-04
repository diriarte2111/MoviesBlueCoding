# MoviesBlueCoding

Movies IMBD app for Blue Coding

Two tab sections:

1) Movies: List of movies released from 01/01/2019 until 07/31/2019 in order to see more details like vote average, because recent launched movies don't have votes yet. 

   -  Paging enabled: When you don't have the page in your local dataBase (which is using CoreData) app will fetch page from API, when you have it app will load from local dataBase. This was done because API is always fetching with paging in order to avoid overloading the request with a lot of information.

    - You can add movies to favorites using "hearth" button, located in upper right corner on each item, which will change according to your favorites selection. 
    
    - You can add movies to watch list using the "paper" button, located in upper left corner on each item, which will show you which movies you have there.

    - You can acess more movie detail by tapping into each item.
    
    - You can search using the field located in navigation bar. 

2) Favorites: You will see here  movies you selected as favorites in "Movies" section. 

    - You can acess more movie detail by tapping into each item.

     You can search using the field located in navigation bar. 

Menu section:

1) Watch list: You will access the watch list from here, you will see a table with the titles that you added to this list.
