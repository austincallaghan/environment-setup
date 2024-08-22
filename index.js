import { intro, outro, confirm, select, spinner } from "@clack/prompts";

intro("create-my-app");

const shouldContinue = await confirm({
  message: "Do you want to continue?",
});

const projectType = await select({
  message: "Pick a project type.",
  options: [
    { value: "ts", label: "TypeScript" },
    { value: "js", label: "JavaScript" },
    { value: "coffee", label: "CoffeeScript", hint: "oh no" },
  ],
});

const s = spinner();
s.start("Installing via npm");

await setTimeout(2000);

s.stop("Installed via npm");

outro("You're all set!");
