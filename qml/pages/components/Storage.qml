import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {


    /**
     * Get the application's database connection
     */
    function getDatabase() {
        return LocalStorage.openDatabaseSync("harbour-hopscotch", "0.1", "Hopscotch", 100000)
    }


    /**
     * Initialize the tables if needed
     */
    function initialize() {
        try {
            var db = getDatabase();
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)')
                    tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(id TEXT UNIQUE, name TEXT, cover TEXT, author TEXT, price TEXT, type TEXT, rating REAL)')
                })
        } catch (ex) {
            console.debug('initialize:', ex)
        }
    }

    /**
     * Saves a favorite into the database
     * @param favorite The favorite to save: (id, name, icon, type)
     *
     * @return The insertion index
     */
    function saveFavorite(favorite) {
        var success = false
        try {
            if (favorite.Id) favorite.id = favorite.Id
            var db = getDatabase()
            notify('info', 'Adding '+favorite.author+' ...')
            db.transaction(function(tx) {
                var rs = tx.executeSql('INSERT OR REPLACE INTO favorites VALUES (?,?,?,?,?,?,?);',
                                       [favorite.id,favorite.name,favorite.cover,favorite.author,favorite.price, favorite.type, favorite.rating])
                success = rs.rowsAffected > 0
                notify('info', 'Favorite '+favorite.name+' added.')
            })
        } catch (ex) {
            console.debug('saveFavorite:', ex)
        }
        return success
    }

    /**
     * Removes a favorite from the database
     * @param favorite The favorite object to remove
     *
     * @return true if the operation is successful, Error if it failed
     */
    function removeFavorite(favorite) {
        var success = false
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                var rs = tx.executeSql('DELETE FROM favorites WHERE id = ?;',
                                       [favorite.id])
                success = rs.rowsAffected > 0
                notify('info', 'Favorite '+favorite.name+' removed.')
            })
        } catch (ex) {
            console.debug('removeFavorite:', ex)
        }
        return success
    }

    /**
     * Removes a favorite from the database
     * @param favorite The favorite object to remove
     *
     * @return true if the operation is successful, Error if it failed
     */
    function clearFavorites() {
        var success = false
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                var rs = tx.executeSql('DELETE FROM favorites;')
                success = rs.rowsAffected > 0
                notify('info', 'Favorites cleared.')
            })
        } catch (ex) {
            console.debug('clearFavorites:', ex)
        }
        return success
    }

    /**
     * Gets the favorites from the database
     *
     * @return The collection of favorites stored or an empty list
     */
    function getFavorites() {
        var res= []
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                var rs = tx.executeSql('SELECT id,name,cover,author,price,type,rating FROM favorites;')
                if (rs.rows.length > 0) {
                    for(var i = 0; i < rs.rows.length; i++) {
                        var currentItem = rs.rows.item(i)
                        res.push({'Id': currentItem.id,
                                  'name': currentItem.name,
                                  'cover': currentItem.cover,
                                  'author': currentItem.author,
                                  'price': currentItem.price,
                                  'type': currentItem.type,
                                  'rating': currentItem.rating})
                    }
                }
            })
        } catch (ex) {
            console.debug('getFavorites:', ex)
        }
        return res
    }

    /**
     *Checks if an item is in favorites
     *
    */
    function inFavorites(item) {
            var res = false
            try {
                var db = getDatabase()
                db.transaction(function(tx) {
                                   var rs = tx.executeSql('SELECT id FROM favorites '+
                                                          'WHERE id = ?;',
                                                          [item.id])
                                   res = rs.rows.length > 0
                               })
            } catch (ex) {
                console.debug('inDownloads:', ex)
            }
            return res
        }

    /**
     * Saves a setting into the database
     * @param setting The setting to save
     * @param value The value for the setting to save
     *
     * @return true if the operation is successfull, false otherwise
     */
    function setSetting(setting, value) {
        var success = false
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value])
                success = rs.rowsAffected > 0
            })
        } catch (ex) {
            console.debug('setSetting:', ex)
        }
        return success
    }

    /**
     * Retrieves a setting from the database
     * @param setting The setting to retrieve
     * @param defaultValue The default value if no value was found
     *
     * @return The value for the setting
     */
    function getSetting(setting, defaultValue) {
        var res = defaultValue
        try {
            var db = getDatabase();
            db.transaction(function(tx) {
                var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
                if (rs.rows.length > 0) {
                    res = rs.rows.item(0).value;
                }
            })
        } catch (ex) {
            console.debug('getSetting:', ex)
        }
        return res
    }
    Component.onCompleted: {
        initialize()
    }

}
 
