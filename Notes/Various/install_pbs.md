# Install

## Signatures manquantes

Retirer les signatures dans .config

`scripts/config -d CONFIG_SYSTEM_TRUSTED_KEYS`

Note: possible cause du bug suivant

## Freeze

Sur une machine physique, le kernel freeze a `Loading initial ramdisk ...`.

Le lancer sur une machine virtuelle regle le probleme.

Note: Sur la machine virtuelle, il faut attendre 20 secondes sur `Loading initial ramdisk ...` avant que cela poursuive.

## Mauvaise installation des headers

La commande `sudo make headers_install` doit etre remplacee par `sudo make headers_install INSTALL_HDR_PATH=/usr`, sans quoi ils ne sont pas installés au bon endroit, et ne sont ensuite pas trouvés.

## Nom de constante incorrect

`bpf/user/agent.h`:

``` cpp
-#define BPF_GHOST_SCHED_MAX_[...]
+#define BPF_GHOST_MAX_[...]
```

## File not found

Un assert fail dans les agents au runtime, avec l'erreur file not found.

Une issue similaire sur le git indique que `...GHOST` doit etre mis a `y` dans `.config`.

Solution: Activer `CONFIG_SCHED_CLASS_GHOST` dans .config



# PyBind

## Libbpf static vs shared

Avec le build initial, libbpf est compilé est lié en tant que librairie statique.

Or pour utiliser pybind, il est necessaire de compiler en Position Independant Code.

Le linker sort donc une erreur disant que libbpf doit etre compilé avec l'option -fPIC.

La solution ne consiste pas a essayer de mettre des -fPIC partout, mais simplement a remplacer les occurences de `libbpf.a` par `libbpf.so` dans `third_party/linux.BUILD` et ajouter `out_shared_libs = ["libbpf.so"],`

## libbpf.so.0 not found

PyBind cherche un libbpf.so.0, il suffit de copier le libbpf.so: faire un cp (ou un ln ?), et ajouter libbpf.so.0 dans les produits dans linux.BUILD
