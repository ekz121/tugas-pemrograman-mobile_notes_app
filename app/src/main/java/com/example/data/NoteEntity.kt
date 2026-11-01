package com.example.data

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Entity(tableName = "notes")
data class NoteEntity(
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "_id")
    val id: Int = 0,
    @ColumnInfo(name = "isImportant")
    val isImportant: Boolean = false,
    @ColumnInfo(name = "number")
    val number: Int = 1,
    @ColumnInfo(name = "title")
    val title: String,
    @ColumnInfo(name = "description")
    val description: String,
    @ColumnInfo(name = "time")
    val time: String = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault()).format(Date()),
    @ColumnInfo(name = "colorIndex")
    val colorIndex: Int = 0
) {
    fun getFormattedDate(): String {
        return try {
            val parser = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
            val date = parser.parse(time) ?: Date()
            SimpleDateFormat("MMM d, yyyy · hh:mm a", Locale.getDefault()).format(date)
        } catch (_: Exception) {
            try {
                val parser2 = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
                val date2 = parser2.parse(time) ?: Date()
                SimpleDateFormat("MMM d, yyyy · hh:mm a", Locale.getDefault()).format(date2)
            } catch (_: Exception) {
                time
            }
        }
    }

    fun getPriorityLabel(): String {
        return when (number) {
            0 -> "None"
            1 -> "Low"
            2 -> "Normal"
            3 -> "Medium"
            4 -> "High"
            5 -> "Urgent"
            else -> "P$number"
        }
    }
}
