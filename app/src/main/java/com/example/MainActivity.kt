package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.Crossfade
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.data.NoteDatabase
import com.example.data.NoteEntity
import com.example.ui.NoteViewModel
import com.example.ui.Screen
import com.example.ui.screens.AddEditNoteScreen
import com.example.ui.screens.NoteDetailScreen
import com.example.ui.screens.NoteListScreen
import com.example.ui.theme.MyApplicationTheme
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val viewModel: NoteViewModel = viewModel(
                        factory = NoteViewModel.Factory(application)
                    )

                    // Seed helpful starter notes if first run
                    LaunchedEffect(Unit) {
                        withContext(Dispatchers.IO) {
                            val db = NoteDatabase.getDatabase(applicationContext)
                            val dao = db.noteDao()
                            // If empty, seed initial notes
                            val existing = dao.insert(
                                NoteEntity(
                                    isImportant = true,
                                    number = 5,
                                    title = "Welcome to Note App! 📝",
                                    description = "This app demonstrates a clean SQLite/Room database architecture with importance indicators, priority slider (0-5), and pastel color cards.",
                                    colorIndex = 1
                                )
                            )
                            if (existing > 0) {
                                dao.insert(
                                    NoteEntity(
                                        isImportant = false,
                                        number = 3,
                                        title = "Hallo Teman Teman",
                                        description = "Selamat Belajar Mobile Programming & Database! Tap to view details or edit.",
                                        colorIndex = 0
                                    )
                                )
                                dao.insert(
                                    NoteEntity(
                                        isImportant = false,
                                        number = 2,
                                        title = "Simpan Data & Testing",
                                        description = "Data is safely persisted in the local SQLite database (notes.db) and survives app restarts.",
                                        colorIndex = 2
                                    )
                                )
                            }
                        }
                    }

                    NoteAppContent(viewModel = viewModel)
                }
            }
        }
    }
}

@Composable
fun NoteAppContent(
    viewModel: NoteViewModel,
    modifier: Modifier = Modifier
) {
    val currentScreen by viewModel.currentScreen.collectAsStateWithLifecycle()

    Crossfade(targetState = currentScreen, label = "ScreenTransition", modifier = modifier) { screen ->
        when (screen) {
            is Screen.List -> {
                NoteListScreen(
                    viewModel = viewModel,
                    onAddNoteClick = { viewModel.navigateToAdd() },
                    onNoteClick = { noteId -> viewModel.navigateToDetail(noteId) }
                )
            }
            is Screen.Detail -> {
                NoteDetailScreen(
                    viewModel = viewModel,
                    onBackClick = { viewModel.navigateToList() },
                    onEditClick = { note -> viewModel.navigateToEdit(note) }
                )
            }
            is Screen.AddEdit -> {
                AddEditNoteScreen(
                    viewModel = viewModel,
                    onBackClick = {
                        if (viewModel.editingNoteId != null) {
                            viewModel.navigateToDetail(viewModel.editingNoteId!!)
                        } else {
                            viewModel.navigateToList()
                        }
                    }
                )
            }
        }
    }
}
