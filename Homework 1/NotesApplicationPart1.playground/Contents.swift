import UIKit


struct Note {
    // Struct holding note information
    var noteId: Int
    var noteName: String
    var noteText: String
    var noteTags: [String]
    var noteIsFavorite: Bool
    var noteCreationDate: Date
    var noteDeletionDate: Date?
}


struct NoteDataManager {
    // Struct operating over Note struct
    var notesArray = [Note]()
    var notesDeletedArray = [Note]()
    
    mutating func createNote(noteName: String, noteText: String, noteTags: [String]) {
        // Function creating new note. Date is setted automatically as well as id
        if !checkNoteIfExists(noteName: noteName) {
            let newNote = Note(noteId: notesArray.count, noteName: noteName, noteText: noteText, noteTags: noteTags, noteIsFavorite: false, noteCreationDate: Date(), noteDeletionDate: nil)
            notesArray.append(newNote)
        } else {
            print("There is already note with such a name!")
        }
    }
    
    func searchNoteByName(noteName: String) -> Note? {
        // Function searching note by its name
        for someNote in notesArray {
            if someNote.noteName == noteName {
                return someNote
            }
        }
        return nil
    }
    
    mutating func changeNoteFavoutiteStatus(noteName: String) {
        // Function setting note favourite status to opposite value
        if let index = notesArray.firstIndex(where: { $0.noteName == noteName }) {
            notesArray[index].noteIsFavorite = !notesArray[index].noteIsFavorite
        }
    }
    
    func checkNoteIfExists(noteName: String) -> Bool {
        // Function checking if note exists
        for someNote in notesArray {
            if someNote.noteName == noteName {
                return true
            }
        }
        return false
    }
    
    mutating func recoverNotesIds() {
        if notesArray.count > 1 {
            for i in 0...notesArray.count {
                notesArray[i].noteId = i
            }
        } else if notesArray.count == 1 {
            notesArray[0].noteId = 0
        }
    }
    
    mutating func recoverDeletedNotesIds() {
        if notesDeletedArray.count > 1 {
            for i in 0...notesDeletedArray.count {
                notesDeletedArray[i].noteId = i
            }
        } else if notesDeletedArray.count == 1 {
            notesDeletedArray[0].noteId = 0
        }
    }
    
    mutating func deleteNote(noteName: String) {
        // Function deleting note from array
        for var someNote in notesArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                someNote.noteId = notesDeletedArray.count
                someNote.noteDeletionDate = Date()
                notesDeletedArray.append(someNote)
                notesArray.remove(at: deletedId)
                recoverNotesIds()
            }
        }
    }
    
    mutating func restoreNote(noteName: String) {
        // Function recovering note from "deleted"
        for var someNote in notesDeletedArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                someNote.noteId = notesArray.count
                someNote.noteDeletionDate = nil
                notesArray.append(someNote)
                notesDeletedArray.remove(at: deletedId)
                recoverDeletedNotesIds()
            }
        }
    }
    
    mutating func sortNotesArrayByDate(ascending: Bool) {
        // Sort notes in array by date
        if ascending {
            notesArray.sort(by: { $0.noteCreationDate < $1.noteCreationDate })
        } else {
            notesArray.sort(by: { $0.noteCreationDate > $1.noteCreationDate })
        }
    }
    
    mutating func sortNotesArrayByName() {
        // Sort notes in array by name
        notesArray.sort(by: { $0.noteName < $1.noteName })
    }
    
    mutating func sortNotesArrayByFavourite() {
        // Sort notes in array by favourite status
        notesArray.sort(by: { $0.noteIsFavorite && !$1.noteIsFavorite })
    }
    
    func filterByTag(noteTag: String)-> [Note]{
        // Function filtering notes by provided tag
        var resultNotes = [Note]()
        for someNote in notesArray {
            if someNote.noteTags.contains(noteTag) {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
    
    func filterByDateBefore(noteDay: Date)-> [Note]{
        // Function filtering notes before provided date
        var resultNotes = [Note]()
        for someNote in notesArray {
            if someNote.noteCreationDate < noteDay {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
    
    func filterByDateAfter(noteDay: Date)-> [Note]{
        // Function filtering notes after provided date
        var resultNotes = [Note]()
        for someNote in notesArray {
            if someNote.noteCreationDate > noteDay {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
}


print("Stupid and simple tests :)")
print("---------------------------------------------------------------------------------------")
// Create strunct and test length
var notes = NoteDataManager()
print("Note array length: \(notes.notesArray.count)")
print("---------------------------------------------------------------------------------------")
// Add two notes and test length
notes.createNote(noteName: "First note", noteText: "Lorem ipsum", noteTags: ["pizza"])
notes.createNote(noteName: "A Second note", noteText: "Lorem ipsum", noteTags: ["burger", "pizza"])
// Test to create note with same name
notes.createNote(noteName: "First note", noteText: "Lorem ipsum else", noteTags: ["pizza"])
print("Note array length: \(notes.notesArray.count)")
print("---------------------------------------------------------------------------------------")
// Change status of first note to favourite
notes.changeNoteFavoutiteStatus(noteName: "A Second note")
print(notes.notesArray[1].noteIsFavorite)
print("---------------------------------------------------------------------------------------")
// Test search note function
let foundNote1 = notes.searchNoteByName(noteName: "First note")
print(foundNote1 ?? "Not found")
print("---------------------------------------------------------------------------------------")
let foundNote2 = notes.searchNoteByName(noteName: "First noted text")
print(foundNote2 ?? "Not found")
print("---------------------------------------------------------------------------------------")
// Test checking existence function
let existence = notes.checkNoteIfExists(noteName: "First note")
print(existence)
print("---------------------------------------------------------------------------------------")
// Deleting test
notes.deleteNote(noteName: "A Second note")
print(notes.notesArray.count)
print(notes.notesDeletedArray.count)
print("---------------------------------------------------------------------------------------")
// Restoring test
notes.restoreNote(noteName: "A Second note")
print(notes.notesArray.count)
print(notes.notesDeletedArray.count)
print("---------------------------------------------------------------------------------------")
// Diffirent sort function tests
notes.deleteNote(noteName: "First note")
notes.restoreNote(noteName: "First note")
notes.sortNotesArrayByDate(ascending: true)
print(notes.notesArray)
print("---------------------------------------------------------------------------------------")
notes.sortNotesArrayByName()
print(notes.notesArray)
print("---------------------------------------------------------------------------------------")
notes.sortNotesArrayByFavourite()
print(notes.notesArray)
print("---------------------------------------------------------------------------------------")
// Filter function test
var tagFilter1 = notes.filterByTag(noteTag: "burger")
print(tagFilter1)
print("---------------------------------------------------------------------------------------")
var tagFilter2 = notes.filterByTag(noteTag: "pizza")
print(tagFilter2)
print("---------------------------------------------------------------------------------------")



