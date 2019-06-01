# MPLS Lab

Cette experiance vise à créer un réseau dit "nuage" d'un fournisseur d'acces.
Il est composé de tout les routeurs `NG-*` et utilise un routage OSPF en interne avec un VRF pour la gestion du client.
Le client est représenté par les routeurs `CE-*` et utilise un routage OSPF en interne avec une zone par site.
Enfin, le réseau du client est relié à internet par un routeur d'acces (`CE-5`) utilisant un NAT.

> Il semble y avoir un problème de ping a cause du nat.
> Le ping type UDP fonctionne mais le premier ping échoue à chaque fois quand il est en direction d'une adresse de l'internet (`1.0.0.2`)
> Le ping type ICMP vers l'exterieur, ne fonctionne simplement pas.