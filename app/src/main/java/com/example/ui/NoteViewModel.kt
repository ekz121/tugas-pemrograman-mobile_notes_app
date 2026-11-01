package com.example.ui

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.example.data.NoteDatabase
import com.example.data.NoteEntity
import com.example.data.NoteRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

sealed interface Screen {
    data object List : Screen
    data class Detail(val noteId: Int) : Screen
    data class AddEdit(val noteId: Int? = null) : Screen
}

@OptIn(ExperimentalCoroutinesApi::class)
class NoteViewModel(
    application: Application,
    private val repository: NoteRepository
) : AndroidViewModel(application) {

    private val _currentScreen = MutableStateFlow<Screen>(Screen.List)
    val currentScreen: StateFlow<Screen> = _currentScreen.asStateFlow()

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private val _filterImportantOnly = MutableStateFlow(false)
    val filterImportantOnly: StateFlow<Boolean> = _filterImportantOnly.asStateFlow()

    private val _activeNoteId = MutableStateFlow<Int?>(null)
    val selectedNote: StateFlow<NoteEntity?> = _activeNoteId.flatMapLatest { id ->
        if (id == null) MutableStateFlow(null)
        else repository.getNoteById(id)
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = null
    )

    val notes: StateFlow<List<NoteEntity>> = combine(
        repository.allNotes,
        _searchQuery,
        _filterImportantOnly
    ) { allNotes, query, importantOnly ->
        allNotes.filter { note ->
            val matchesQuery = query.isBlank() ||
                    note.title.contains(query, ignoreCase = true) ||
                    note.description.contains(query, ignoreCase = true)
            val matchesImportance = !importantOnly || note.isImportant
            matchesQuery && matchesImportance
        }
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = emptyList()
    )

    // Form states for Add/Edit
    var editingNoteId: Int? = null
        private set
    val editTitle = MutableStateFlow("")
    val editDescription = MutableStateFlow("")
    val editIsImportant = MutableStateFlow(false)
    val editNumber = MutableStateFlow(1) // 0 to 5
    val editColorIndex = MutableStateFlow(0) // 0 to 5

    val titleError = MutableStateFlow<String?>(null)
    val descError = MutableStateFlow<String?>(null)
    val isSaving = MutableStateFlow(false)

    fun onSearchQueryChange(query: String) {
        _searchQuery.value = query
    }

    fun toggleFilterImportant() {
        _filterImportantOnly.value = !_filterImportantOnly.value
    }

    fun navigateToList() {
        _currentScreen.value = Screen.List
        _activeNoteId.value = null
    }

    fun navigateToDetail(noteId: Int) {
        _activeNoteId.value = noteId
        _currentScreen.value = Screen.Detail(noteId)
    }

    fun navigateToAdd() {
        editingNoteId = null
        editTitle.value = ""
        editDescription.value = ""
        editIsImportant.value = false
        editNumber.value = 1
        editColorIndex.value = (0..5).random()
        titleError.value = null
        descError.value = null
        _currentScreen.value = Screen.AddEdit(null)
    }

    fun navigateToEdit(note: NoteEntity) {
        editingNoteId = note.id
        editTitle.value = note.title
        editDescription.value = note.description
        editIsImportant.value = note.isImportant
        editNumber.value = note.number
        editColorIndex.value = note.colorIndex
        titleError.value = null
        descError.value = null
        _currentScreen.value = Screen.AddEdit(note.id)
    }

    fun saveNote(onSuccess: () -> Unit) {
        val title = editTitle.value.trim()
        val desc = editDescription.value.trim()

        var hasError = false
        if (title.isEmpty()) {
            titleError.value = "The title cannot be empty"
            hasError = true
        } else {
            titleError.value = null
        }

        if (desc.isEmpty()) {
            descError.value = "The desc cannot be empty"
            hasError = true
        } else {
            descError.value = null
        }

        if (hasError) return

        viewModelScope.launch {
            isSaving.value = true
            val nowIso = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault()).format(Date())

            val currentId = editingNoteId
            if (currentId != null && currentId > 0) {
                // Update
                val updated = NoteEntity(
                    id = currentId,
                    isImportant = editIsImportant.value,
                    number = editNumber.value,
                    title = title,
                    description = desc,
                    time = nowIso,
                    colorIndex = editColorIndex.value
                )
                repository.update(updated)
                _activeNoteId.value = currentId
                _currentScreen.value = Screen.Detail(currentId)
            } else {
                // Create
                val newNote = NoteEntity(
                    isImportant = editIsImportant.value,
                    number = editNumber.value,
                    title = title,
                    description = desc,
                    time = nowIso,
                    colorIndex = editColorIndex.value
                )
                repository.insert(newNote)
                _currentScreen.value = Screen.List
            }
            isSaving.value = false
            onSuccess()
        }
    }

    fun deleteNoteById(id: Int, onDeleted: () -> Unit) {
        viewModelScope.launch {
            repository.deleteById(id)
            navigateToList()
            onDeleted()
        }
    }

    fun toggleImportance(note: NoteEntity) {
        viewModelScope.launch {
            repository.update(note.copy(isImportant = !note.isImportant))
        }
    }

    class Factory(private val application: Application) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            val db = NoteDatabase.getDatabase(application)
            val repo = NoteRepository(db.noteDao())
            return NoteViewModel(application, repo) as T
        }
    }
}
