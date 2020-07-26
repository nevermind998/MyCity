using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;

namespace backendPoSlojevima.UI
{
    public class DislajkoviUI : IDislajkoviUI
    {
        private readonly IDislajkoviBL _IDislajkoviBL;
        private readonly IGradKorisniciUI _IGradKorisniciUI;

        public DislajkoviUI (IDislajkoviBL IDislajkoviBL, IGradKorisniciUI IGradKorisniciUI)
        {
            _IDislajkoviBL = IDislajkoviBL;
            _IGradKorisniciUI = IGradKorisniciUI;
        }

        public void deleteDislajkoveByIdKorisnika(long idKorisnika)
        {
            _IDislajkoviBL.deleteDislajkoveByIdKorisnika(idKorisnika);
        }

        public void deleteDislajkoveByIdObjave(long idObjave)
        {
            _IDislajkoviBL.deleteDislajkoveByIdObjave(idObjave);
        }

        public List<Dislajkovi> getAllDislajkovi()
        {
            return _IDislajkoviBL.getAllDislajkovi();
        }

        public long getBrojDislajkovaByIdObjave(PrihvatanjeIdObjave objava)
        {
            return _IDislajkoviBL.getBrojDislajkovaByIdObjave(objava.idObjave);
        }

        public int getDislajkByKorisnikId(long idKorisnika, long idObjave)
        {
            return _IDislajkoviBL.getDislajkByKorisnikId(idKorisnika, idObjave);
        }

        public List<Dislajkovi> getDislajkoveByIdObjave(long idObjave)
        {
            return _IDislajkoviBL.getDislajkoveByIdObjave(idObjave);
        }

        public List<Dislajkovi> getDislajkoveByKorisnikId(PrihvatanjeIdKorisnika korisnika)
        {
            return _IDislajkoviBL.getDislajkoveByKorisnikId(korisnika.idKorisnika);
        }

        public List<KorisnikSaGradovima> getKorisnikeKojiDislajkujuByIdObjave(PrihvatanjeIdObjave objava)
        {
            var korisnici = _IDislajkoviBL.getKorisnikeKojiDislajkujuByIdObjave(objava.idObjave);
            var listaKorisnika = new List<KorisnikSaGradovima>();
            foreach(var korisnik in korisnici)
            {
                var vlasnik = new KorisnikSaGradovima();
                vlasnik.id = korisnik.id;
                vlasnik.ime = korisnik.ime;
                vlasnik.prezime = korisnik.prezime;
                vlasnik.poeni = korisnik.poeni;
                vlasnik.Token = korisnik.Token;
                vlasnik.uloga = korisnik.uloga;
                vlasnik.username = korisnik.username;
                vlasnik.password = korisnik.password;
                vlasnik.urlSlike = korisnik.urlSlike;
                vlasnik.biografija = korisnik.biografija;
                vlasnik.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
                if (vlasnik != null)
                {
                    listaKorisnika.Add(vlasnik);
                }

            }
            return listaKorisnika;
        }

        public void saveDislajk(Dislajkovi data)
        {
            _IDislajkoviBL.saveDislajk(data);
        }
    }
}
