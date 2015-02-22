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
        var insertIndex = -1
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                var rs = tx.executeSql('INSERT OR REPLACE INTO favorites VALUES (?,?,?,?);',
                                       [favorite.id,favorite.name,favorite.icon,favorite.type])
                insertIndex = rs.insertId
            })
        } catch (ex) {
            console.debug('saveFavorite:', ex)
        }
        return insertIndex
    }

    /**
     * Removes a favorite from the database
     * @param index The index to remove
     *
     * @return true if the operation is successful, Error if it failed
     */
    function removeFavorite(index) {
        var success = false
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                var rs = tx.executeSql('DELETE FROM favorites WHERE ROWID = ?;',
                                       [index])
                success = rs.rowsAffected > 0
            })
        } catch (ex) {
            console.debug('removeFavorite:', ex)
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
                var rs = tx.executeSql('SELECT rowid,itemId,name,iconSource,type FROM favorites;')
                if (rs.rows.length > 0) {
                    for(var i = 0; i < rs.rows.length; i++) {
                        var currentItem = rs.rows.item(i)
                        res.push({'id': currentItem.itemId,
                                  'name': currentItem.name,
                                  'icon': currentItem.iconSource,
                                  'type': currentItem.type,
                                  'rowId': currentItem.rowid})
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
                                   var rs = tx.executeSql('SELECT itemId FROM downloads '+
                                                          'WHERE itemId = ?;',
                                                          [item.id])
                                   res = rs.rows.length > 0
                               })
            } catch (ex) {
                console.debug('inDownloads:', ex)
            }
            return res
        }
    /**
     * Saves a movie into the downloads
     * @param movie The item to save: (id, name, path, iconSource, type)
     */
    function addToDownloads(item) {
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                               tx.executeSql('INSERT OR REPLACE INTO downloads '+
                                             'VALUES (?, ?, ?, ?, ?);',
                                             [item.Id, item.name,
                                              item.path, item.iconSource,
                                              item.type])
                           })
        } catch (ex) {
            console.debug('addToDownloads:', ex)
        }
    }

    /**
     * Deletes an item from the downloads
     * @param item The item to remove: (id)
     */
    function removeFromDownloads(item) {
        try {
            var info = getDownload(item.Id)[0]
            py.call('os.remove', [info.audio], function (result) {
                console.log('File removed.');
                var db = getDatabase()
                db.transaction(function(tx) {
                                   tx.executeSql('DELETE FROM downloads '+
                                                 'WHERE itemId = ?;',
                                                 [item.Id])
                               })
            });
        } catch (ex) {
            console.debug('removeFromDownloads:', ex)
        }
    }

    /**
     * Gets the downloads from the database
     *
     * @return The collection of items in the downloads or an empty list
     */
    function getDownloads() {
        var res = []
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                               var rs = tx.executeSql('SELECT itemId, name, path, iconSource, type FROM downloads;')
                               for (var i = 0; i < rs.rows.length; i ++) {
                                   var currentItem = rs.rows.item(i)
                                   res.push({
                                                'Id': currentItem.itemId,
                                                'name': currentItem.name,
                                                'audio': currentItem.path,
                                                'icon': currentItem.iconSource,
                                                'type': currentItem.type,
                                            })
                               }
                           })
        } catch (ex) {
            console.debug('getDownloads:', ex)
        }
        return res
    }
    /**
     * Gets a download from the database
     *
     * @return The collection of items in the downloads or an empty list
     */
    function getDownload(id) {
        var res = []
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                               var rs = tx.executeSql('SELECT itemId, name, path, iconSource, type FROM downloads WHERE id = '+id+';')
                               for (var i = 0; i < rs.rows.length; i ++) {
                                   var currentItem = rs.rows.item(i)
                                   res.push({
                                                'Id': currentItem.itemId,
                                                'name': currentItem.name,
                                                'audio': currentItem.path,
                                                'icon': currentItem.iconSource,
                                                'type': currentItem.type,
                                            })
                               }
                           })
        } catch (ex) {
            console.debug('getDownloads:', ex)
        }
        return res
    }

    /**
     * Checks if an is in the downloads
     * @param item The song/album/artist to check
     * @return TRUE if the movie is in the downloads, FALSE otherwise
     */
    function inDownloads(item) {
        var res = false
        try {
            var db = getDatabase()
            db.transaction(function(tx) {
                               var rs = tx.executeSql('SELECT itemId FROM downloads '+
                                                      'WHERE itemId = ?;',
                                                      [item.Id])
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
 
