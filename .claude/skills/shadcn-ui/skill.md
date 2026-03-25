---
name: shadcn-ui
description: shadcn/ui component library methodology. Guides usage of Radix UI primitives + Tailwind CSS, component installation, theming with CSS variables, CVA variants, form patterns with react-hook-form + zod, dark mode, and component customization. Claude invokes this when building UI with shadcn/ui.
auto_invoke: true
tags: [shadcn, radix-ui, tailwind, components, theming, forms, dark-mode]
---

# shadcn/ui Skill

This skill provides a systematic methodology for building interfaces with shadcn/ui — the copy-paste component library built on Radix UI + Tailwind CSS.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- Project uses shadcn/ui (detected: `components/ui/` directory, `@/components/ui` imports)
- User asks to add/customize shadcn/ui components
- Building forms, dialogs, data tables, or command palettes with shadcn/ui
- Theming or dark mode work in a shadcn/ui project
- `/do` routes to FEATURE or CODE involving UI components in a shadcn/ui project

**Do NOT invoke when:**
- Project doesn't use shadcn/ui
- Task is about a different component library (MUI, Ant Design, Chakra)
- Task is pure design system theory (use ui-ux-pro-max skill)

## Core Principles

1. **Own your components** — shadcn/ui components are copied into your project, not imported from a package. You own and customize them directly
2. **Composition over configuration** — Use Radix UI primitives for behavior, Tailwind for styling
3. **Accessible by default** — Radix UI handles ARIA, keyboard nav, and focus management
4. **Theme with CSS variables** — All colors are CSS custom properties, enabling dark mode and custom themes
5. **Type-safe variants** — Use CVA (Class Variance Authority) for component variant APIs

## Architecture

### Project Structure

```
src/
├── components/
│   ├── ui/                    # shadcn/ui base components (DO NOT put custom logic here)
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── dialog.tsx
│   │   ├── select.tsx
│   │   ├── table.tsx
│   │   └── ...
│   ├── forms/                 # Form compositions using ui/ components
│   │   ├── login-form.tsx
│   │   └── settings-form.tsx
│   ├── layouts/               # Layout components
│   │   ├── sidebar.tsx
│   │   └── page-header.tsx
│   └── features/              # Feature-specific compound components
│       ├── user-table.tsx
│       └── dashboard-stats.tsx
├── lib/
│   └── utils.ts               # cn() utility (clsx + tailwind-merge)
└── styles/
    └── globals.css            # CSS variables for theming
```

**Rule**: Never put business logic in `components/ui/`. Those are primitives. Build feature components that compose ui/ primitives.

### Utility: cn() Function

```typescript
// lib/utils.ts — THE most important utility
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

Always use `cn()` for conditional and mergeable class names:
```tsx
<div className={cn("rounded-lg border p-4", isActive && "border-primary", className)} />
```

## Theming Protocol

### CSS Variable System

```css
/* globals.css — shadcn/ui theming */
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    /* ... dark variants */
  }
}
```

**Color format**: HSL values WITHOUT `hsl()` wrapper. Tailwind applies it:
```
✅ --primary: 222.2 47.4% 11.2%;
❌ --primary: hsl(222.2, 47.4%, 11.2%);
```

**Adding custom colors**:
1. Add CSS variable in globals.css (both `:root` and `.dark`)
2. Extend `tailwind.config.ts` to reference it
3. Use in components as `bg-custom` or `text-custom`

### Dark Mode

**Implementation** (next-themes recommended):
```tsx
// app/layout.tsx
import { ThemeProvider } from "next-themes";

export default function RootLayout({ children }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem disableTransitionOnChange>
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
```

**Theme toggle component**:
```tsx
import { useTheme } from "next-themes";
import { Button } from "@/components/ui/button";
import { Moon, Sun } from "lucide-react";

export function ThemeToggle() {
  const { setTheme, theme } = useTheme();
  return (
    <Button variant="ghost" size="icon" onClick={() => setTheme(theme === "light" ? "dark" : "light")}>
      <Sun className="h-5 w-5 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-5 w-5 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
    </Button>
  );
}
```

## Form Patterns

### react-hook-form + zod + shadcn/ui Form

```tsx
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const formSchema = z.object({
  email: z.string().email("Please enter a valid email"),
  name: z.string().min(2, "Name must be at least 2 characters"),
});

export function UserForm() {
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: { email: "", name: "" },
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    // Handle submission
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField control={form.control} name="name" render={({ field }) => (
          <FormItem>
            <FormLabel>Name</FormLabel>
            <FormControl><Input placeholder="John Doe" {...field} /></FormControl>
            <FormMessage />
          </FormItem>
        )} />
        <FormField control={form.control} name="email" render={({ field }) => (
          <FormItem>
            <FormLabel>Email</FormLabel>
            <FormControl><Input type="email" placeholder="john@example.com" {...field} /></FormControl>
            <FormMessage />
          </FormItem>
        )} />
        <Button type="submit" disabled={form.formState.isSubmitting}>
          {form.formState.isSubmitting ? "Saving..." : "Save"}
        </Button>
      </form>
    </Form>
  );
}
```

**Form rules**:
- Always use `zodResolver` for validation
- Always provide `defaultValues`
- Always show `<FormMessage />` for errors
- Disable submit button during submission
- Show loading state on submit button

### Data Table Pattern

```tsx
import { DataTable } from "@/components/ui/data-table";
import { ColumnDef } from "@tanstack/react-table";

const columns: ColumnDef<User>[] = [
  { accessorKey: "name", header: "Name" },
  { accessorKey: "email", header: "Email" },
  {
    accessorKey: "status",
    header: "Status",
    cell: ({ row }) => <Badge variant={row.original.status === "active" ? "default" : "secondary"}>{row.original.status}</Badge>,
  },
  {
    id: "actions",
    cell: ({ row }) => (
      <DropdownMenu>
        <DropdownMenuTrigger asChild><Button variant="ghost" size="icon"><MoreHorizontal /></Button></DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          <DropdownMenuItem>Edit</DropdownMenuItem>
          <DropdownMenuItem className="text-destructive">Delete</DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    ),
  },
];
```

## Component Customization Rules

1. **Extend, don't fork** — Add variants to existing components via CVA
2. **Use className prop** — All shadcn/ui components accept className for overrides
3. **Wrap for behavior** — Create wrapper components for business logic
4. **Keep ui/ clean** — Run `npx shadcn@latest diff` to see what you've changed

### Adding a Variant

```tsx
// components/ui/button.tsx — extend existing variants
const buttonVariants = cva(
  "...",
  {
    variants: {
      variant: {
        // existing variants...
        primary: "...",
        // ADD your custom variant
        success: "bg-green-600 text-white hover:bg-green-700 focus-visible:ring-green-500",
      },
    },
  }
);
```

## Key Components Reference

| Component | Radix Primitive | Use Case |
|-----------|----------------|----------|
| Dialog | @radix-ui/react-dialog | Modal dialogs, confirmations |
| Sheet | @radix-ui/react-dialog | Side panels, mobile nav |
| Select | @radix-ui/react-select | Dropdowns with search |
| Popover | @radix-ui/react-popover | Rich tooltips, date pickers |
| Command | cmdk | Command palette (Cmd+K) |
| Tabs | @radix-ui/react-tabs | Tab navigation |
| Accordion | @radix-ui/react-accordion | Collapsible sections |
| Toast | sonner (recommended) | Notifications |
| Table | @tanstack/react-table | Data tables with sort/filter |
| Form | react-hook-form + zod | Validated forms |

## Quality Checklist

Before completing any shadcn/ui task:

- [ ] Components installed via `npx shadcn@latest add [component]`
- [ ] No business logic in `components/ui/` directory
- [ ] `cn()` used for all conditional class names
- [ ] Forms use react-hook-form + zod + shadcn Form components
- [ ] Dark mode tested (all custom colors have dark variants)
- [ ] Custom colors added to both `:root` and `.dark` in globals.css
- [ ] New variants added via CVA, not inline styles
- [ ] Keyboard navigation works (Radix handles most, verify custom parts)
- [ ] Loading and disabled states handled
- [ ] TypeScript types exported for custom component props

## Common Pitfalls

- **Modifying ui/ without tracking** → Run `npx shadcn@latest diff` periodically
- **Missing dark mode variables** → Every custom CSS variable needs a `.dark` variant
- **Inline Tailwind overrides** → Use CVA variants or cn() instead
- **Not using Form components** → Always wrap with `<Form>`, `<FormField>`, `<FormItem>`
- **Importing from wrong path** → Always `@/components/ui/button`, never `shadcn/ui`
- **Forgetting suppressHydrationWarning** → Required on `<html>` when using next-themes

---

**This skill ensures all shadcn/ui implementations follow the library's design philosophy: own your components, compose with primitives, theme with CSS variables.**
