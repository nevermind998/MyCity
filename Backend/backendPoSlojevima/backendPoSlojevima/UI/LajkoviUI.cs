using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI
{
    public class LajkoviUI : ILajkoviUI
    {
        private readonly ILajkoviBL _ILajkoviBL;
        private readonly IGradKorisniciUI _IGradKorisniciUI;

        public LajkoviUI(ILajkoviBL ILajkoviBL, IGradKorisniciUI IGradKorisniciUI)
        {
            _ILajkoviBL = ILajkoviBL;
            _IGradKorisniciUI = IGradKorisniciUI;
        }

        public void deleteLajkoveByIdKorisnika(long idKorisnika)
        {
            _ILajkoviBL.deleteLajkoveByIdKorisnika(idKorisnika);
        }

        public void deleteLajkoveByIdObjave(long idObjave)
        {
            _ILajkoviBL.deleteLajkoveByIdObjave(idObjave);
        }

        public List<Lajkovi> getAllLajkovi()
        {
            return _ILajkoviBL.getAllLajkovi();
        }

        public long getBrojLajkovaByIdObjave(PrihvatanjeIdObjave objava)
        {
            return _ILajkoviBL.getBrojLajkovaByIdObjave(objava.idObjave);
        }

        public List<KorisnikSaGradovima> getKorisnikeKojiLajkujuByIdObjave(PrihvatanjeIdObjave objava)
        {
           // return _ILajkoviBL.getKorisnikeKojiLajkujuByIdObjave(objava.idObjave);
             var korisnici = _ILajkoviBL.getKorisnikeKojiLajkujuByIdObjave(objava.idObjave);
            var listaKorisnika = new List<KorisnikSaGradovima>();
            foreach (var korisnik in korisnici)
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

        public int getLajkByKorisnikId(long idKorisnika, long idObjave)
        {
           return _ILajkoviBL.getLajkByKorisnikId(idKorisnika,idObjave);
        }

        public List<Lajkovi> getLajkoveByIdObjave(long idObjave)
        {
            return _ILajkoviBL.getLajkoveByIdObjave(idObjave);
        }

        public List<Lajkovi> getLajkoveByKorisnikId(PrihvatanjeIdKorisnika korisnik)
        {
            return _ILajkoviBL.getLajkoveByKorisnikId(korisnik.idKorisnika);
        }

        public void saveLajk(Lajkovi data)
        {
            _ILajkoviBL.saveLajk(data);
        }

        
    }
}
