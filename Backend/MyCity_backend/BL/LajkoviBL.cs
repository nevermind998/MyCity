using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Data;

namespace backendPoSlojevima.BL
{
    public class LajkoviBL : ILajkoviBL
    {
        private readonly ILajkoviDAL _ILajkoviDAL;
        private readonly List<Lajkovi> lajkovi;
        private readonly IKorisnikBL _IKorisnikBL;

        public LajkoviBL(ILajkoviDAL ILajkoviDAL, IKorisnikBL IKorisnikBL)
        {
            _ILajkoviDAL = ILajkoviDAL;
            lajkovi = _ILajkoviDAL.getAllLajkovi();
            _IKorisnikBL = IKorisnikBL;

        }

        public List<Lajkovi> getAllLajkovi()
        {
            return _ILajkoviDAL.getAllLajkovi();
        }

        public long getBrojLajkovaByIdObjave(long idObjave)
        {
            var pokupiLajkove = lajkovi.Where(l => l.ObjaveID == idObjave);
            var brojLajkova = pokupiLajkove.Count();
            return brojLajkova;
        }

        public List<Lajkovi> getLajkoveByKorisnikId(long idKorisnika)
        {
            return lajkovi.Where(l => l.KorisnikID == idKorisnika).ToList();
           
        }

        public void saveLajk(Lajkovi data)
        {
             _ILajkoviDAL.saveLajk(data);
        }

       

        public  List<Korisnik> getKorisnikeKojiLajkujuByIdObjave(long idObjave)
        {
            List<Korisnik> korisnici = new List<Korisnik>();
            var korisniciKojiSuLajkovali = getLajkoveByIdObjave(idObjave);
            foreach( var korisnik in korisniciKojiSuLajkovali)
            {
                Korisnik kor = _IKorisnikBL.getKorisnikaById(korisnik.KorisnikID);
                korisnici.Add(kor);
            }
            return korisnici;
        }

        public void deleteLajkoveByIdObjave(long idObjave)
        {
            List<Lajkovi> listaLajkova = getLajkoveByIdObjave(idObjave);
            _ILajkoviDAL.deleteLajk(listaLajkova);
            /*foreach(var lajk in listaLajkova)
            {
                _ILajkoviDAL.deleteLajk(lajk);
            }*/
        }

        public void deleteLajkoveByIdKorisnika(long idKorisnika)
        {
            List<Lajkovi> listaLajkova = getLajkoveByKorisnikId(idKorisnika);
            foreach(var lajk in listaLajkova)
            {
               // _ILajkoviDAL.deleteLajk(lajk);
            }
        }

        public List<Lajkovi> getLajkoveByIdObjave(long idObjave)
        {
            return lajkovi.Where(l => l.ObjaveID == idObjave).ToList();
        }

        public List<Objave> getNajpopularnijeObjave()
        {
            throw new NotImplementedException();
        }

        public int getLajkByKorisnikId(long idKorisnika, long idObjave)
        {
            var check = lajkovi.FirstOrDefault(l => l.ObjaveID == idObjave && l.KorisnikID == idKorisnika);
            if (check != null) return 1;
            else
            {
                return 0;
            }
        }
    }
}
