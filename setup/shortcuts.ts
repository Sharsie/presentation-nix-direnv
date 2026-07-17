import type { NavOperations, ShortcutOptions } from '@slidev/types'
import { recorder } from '@slidev/client/logic/recording.ts'

// https://sli.dev/custom/config-shortcuts
// `c` toggles the webcam overlay (recorder.toggleAvatar) — enable/disable camera.
export default function shortcuts(_nav: NavOperations, base: ShortcutOptions[]): ShortcutOptions[] {
  return [
    ...base,
    {
      name: 'toggle_camera',
      key: 'c',
      fn: () => recorder.toggleAvatar(),
    },
  ]
}
