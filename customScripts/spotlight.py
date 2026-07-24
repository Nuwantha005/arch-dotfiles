import tkinter as tk

class Spotlight:
    def __init__(self):
        self.root = tk.Tk()
        self.root.config(bg='black')
        self.root.attributes('-alpha', 0.4) # Darkness of the rest of the screen
        self.root.attributes('-topmost', True)
        
        # Make window fullscreen and click-through (X11/Wayland bridge dependent)
        self.root.geometry(f"{self.root.winfo_screenwidth()}x{self.root.winfo_screenheight()}+0+0")
        self.root.overrideredirect(True)
        
        # Create canvas for the hole
        self.canvas = tk.Canvas(self.root, bg='black', highlightthickness=0)
        self.canvas.pack(fill='both', expand=True)
        
        self.update_spotlight()
        self.root.mainloop()

    def update_spotlight(self):
        self.canvas.delete("all")
        x = self.root.winfo_pointerx()
        y = self.root.winfo_pointery()
        
        # Draw a clear circle around the cursor position
        r = 80 # Radius of spotlight
        self.canvas.create_oval(x-r, y-r, x+r, y+r, fill='', outline='white', width=2)
        
        self.root.after(10, self.update_spotlight)

if __name__ == "__main__":
    Spotlight()
