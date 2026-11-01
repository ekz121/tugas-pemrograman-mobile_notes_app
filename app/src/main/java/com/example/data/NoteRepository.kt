package com.example.data

import kotlinx.coroutines.flow.Flow

class NoteRepository(private val noteDao: NoteDao) {
    val allNotes: Flow<List<NoteEntity>> = noteDao.getAllNotes()

    fun getNoteById(id: Int): Flow<NoteEntity?> = noteDao.getNoteById(id)

    fun searchNotes(query: String): Flow<List<NoteEntity>> = noteDao.searchNotes(query)

    suspend fun insert(note: NoteEntity): Long = noteDao.insert(note)

    suspend fun update(note: NoteEntity): Int = noteDao.update(note)

    suspend fun delete(note: NoteEntity): Int = noteDao.delete(note)

    suspend fun deleteById(id: Int): Int = noteDao.deleteById(id)
}
