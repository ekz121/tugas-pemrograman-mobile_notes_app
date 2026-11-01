package com.example.data

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface NoteDao {
    @Query("SELECT * FROM notes ORDER BY isImportant DESC, _id DESC")
    fun getAllNotes(): Flow<List<NoteEntity>>

    @Query("SELECT * FROM notes WHERE _id = :id LIMIT 1")
    fun getNoteById(id: Int): Flow<NoteEntity?>

    @Query("SELECT * FROM notes WHERE title LIKE '%' || :query || '%' OR description LIKE '%' || :query || '%' ORDER BY isImportant DESC, _id DESC")
    fun searchNotes(query: String): Flow<List<NoteEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(note: NoteEntity): Long

    @Update
    suspend fun update(note: NoteEntity): Int

    @Delete
    suspend fun delete(note: NoteEntity): Int

    @Query("DELETE FROM notes WHERE _id = :id")
    suspend fun deleteById(id: Int): Int
}
